//
//  CacheManagerTests.swift
//  ToDo
//
//  Created byadmin on 8/6/17.
//  Copyright © 2017 admin. All rights reserved.
//

import XCTest
import Foundation
import CoreData
@testable import ToDo
@testable import Alamofire
import OHHTTPStubs
class CacheManagerTests: XCTestCase {
    var serverManager: PartialMockServerManager!
    var client : CacheMockApiClient!
    var managedObjectContext :NSManagedObjectContext!
    var cacheManager : CacheManager!

    class PartialMockServerManager :ServerManager {
        
        var getAllItemsCallCount : Int! = 0
        var deleteItemCallCount : Int! = 0
        var createNewItemCallCount : Int! = 0
        var updateItemCallCount : Int! = 0
        override func getAllItems() -> DataRequest {
            self.getAllItemsCallCount.increment()
            return super.getAllItems()
        }
        
        override func deleteItem(itemId: Int32) -> DataRequest {
            self.deleteItemCallCount.increment()
            return super.deleteItem(itemId: itemId)
        }
        
        override func createNewItem(item: TodoItem) -> DataRequest {
            self.createNewItemCallCount.increment()
            return super.createNewItem(item:item)
        }
        
        override func updateItem(item: TodoItem) -> DataRequest {
            self.updateItemCallCount.increment()
            return super.updateItem(item: item)
        }
    }
    
    override func setUp(){
        super.setUp()
        self.client = CacheMockApiClient(baseURL:"http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080")
        
        self.serverManager = PartialMockServerManager(client:self.client)
        self.managedObjectContext = CoreDataUnitTestHelper.setUpInMemoryManagedObjectContext()
        self.cacheManager = CacheManager(serverManager:self.serverManager, context: self.managedObjectContext)
    }
    override func tearDown(){
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func testGetAllItemsWhenThereAreItemsInTheDb(){
        _ = self.insertObjectWithId(itemId: 10,context:self.managedObjectContext)
        let expect = expectation(description:"wait until items load")
        self.cacheManager.getAllItems(completion: { (items) in
            XCTAssert(self.serverManager.getAllItemsCallCount == 0, " call server for items")
            expect.fulfill()
        })
        self.waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testGetAllItemsForce(){
        _ = self.insertObjectWithId(itemId: 10,context:self.managedObjectContext)
        let expect = expectation(description:"wait until items load")
        self.cacheManager.getAllItems(force:true,fetchRequest: TodoItem.fetchRequest(), completion: { (items) in
            XCTAssert(self.serverManager.getAllItemsCallCount == 1, " call server for items")
            expect.fulfill()
        })
        self.waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testGetAllItemsWhenNoItemsCallsServerForItems(){
        
        let expect = expectation(description:"wait until items load")
        self.cacheManager.getAllItems(completion: { (items) in
            XCTAssert(self.serverManager.getAllItemsCallCount == 1, "didnt call server for items")
            expect.fulfill()
        })
        self.waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testDeleteItem(){
        
        let fetchReq : NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        let item = self.insertObjectWithId(itemId: 10,context:self.managedObjectContext)

        let expect = expectation(description:"wait until items load")
        self.cacheManager.deleteItem(item:item!, completion: { err in
            XCTAssert(self.serverManager.deleteItemCallCount == 1, "didnt call server for items")
            
            
            let count = try? self.managedObjectContext.count(for:fetchReq)
            
            XCTAssertTrue(count == 0 , "the item was not deleted")
            
            expect.fulfill()
        })
        self.waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testDeleteItemExpectedToReturnError(){
        let fetchReq : NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        let item = self.insertObjectWithId(itemId: 11,context:self.managedObjectContext)
        let expect = expectation(description:"wait until items load")
        self.cacheManager.deleteItem(item:item!, completion: { err in
            XCTAssert(self.serverManager.deleteItemCallCount == 1, "didnt call server for items")
            XCTAssertTrue(err != nil)
            
            let count = try? self.managedObjectContext.count(for:fetchReq)
            
            XCTAssertTrue(count == 1 , "the item was deleted even though the result is failed")
            
            expect.fulfill()
        })
        self.waitForExpectations(timeout: 60, handler: nil)
    }
    
    func insertObjectWithId(itemId:Int32, context: NSManagedObjectContext) ->TodoItem?{
        let item = TodoItem(context: context, title: "LenaAddedThisItem")
        item.id = itemId
        return item
    }
   
    
    func testCreateNewItem(){
        let expect = expectation(description:"create item")
        let fetchReq: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        let differentContext = CoreDataUnitTestHelper.setUpInMemoryManagedObjectContext()
        let item = self.insertObjectWithId(itemId:0,context:differentContext)
        
        self.cacheManager.createNewItem(item:item!, completion:{
            error in
            XCTAssertTrue( error == nil)
            let fetchResults = try? self.managedObjectContext.fetch(fetchReq)
            XCTAssertTrue(fetchResults?.count == 1, "expected 1 item to be in the db")
            let todoItem = fetchResults?[0]
            XCTAssertTrue(todoItem?.id == 1, "The item was not updated in the database")
            expect.fulfill()
        })
        
        self.waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testCreateItemServerReturnError(){
        let expect = expectation(description:"create item")
        let fetchReq: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        let differentContext = CoreDataUnitTestHelper.setUpInMemoryManagedObjectContext()
        let item = self.insertObjectWithId(itemId:0,context:differentContext)
        self.cacheManager.createNewItem(item:item!, completion:{
            error in
            XCTAssertTrue( error != nil)
            let count = try? self.managedObjectContext.count(for:fetchReq)
            XCTAssertTrue(count == 0, "expected 0 item to be in the db")
            expect.fulfill()
        })
        
        self.waitForExpectations(timeout: 60, handler: nil)
    }

    func testUpdateItem(){
        let expect = expectation(description:"update item")
        let fetchReq: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        let differentContext = CoreDataUnitTestHelper.setUpInMemoryManagedObjectContext()
        let item = self.insertObjectWithId(itemId:15, context:self.managedObjectContext)
        let originalItemTitle = item?.title
        
        let updatedItem = self.insertObjectWithId(itemId: 15, context: differentContext)

        
         updatedItem?.title = "updatedItemTitle"
        self.cacheManager.updateItem(item:updatedItem!, completion:{
            error in
            XCTAssertTrue( error == nil)
            let fetchResults = try? self.managedObjectContext.fetch(fetchReq)
            XCTAssertTrue(fetchResults?.count == 1, "expected 1 item to be in the db")
            let todoItem = fetchResults?[0]
            XCTAssertTrue(todoItem?.title != originalItemTitle, "The item was not updated in the database")
            expect.fulfill()
        })
        
        self.waitForExpectations(timeout: 60, handler: nil)
    }
    

    func testUpdateItemWhenItemDoesntExistOnServer(){
        let expect = expectation(description:"update item")
        let fetchReq: NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        let item = self.insertObjectWithId(itemId:16,context:self.managedObjectContext)
        let originalItemTitle = item?.title
        
        let differentContext = CoreDataUnitTestHelper.setUpInMemoryManagedObjectContext()
        let updatedItem = self.insertObjectWithId(itemId: 16,context:differentContext)

        updatedItem?.title = "updatedItemTitle"

        self.cacheManager.updateItem(item:updatedItem!, completion:{
            error in
            XCTAssertTrue( error != nil)
            let fetchResults = try? self.managedObjectContext.fetch(fetchReq)
            XCTAssertTrue(fetchResults?.count == 1, "expected 1 item to be in the db")
            let todoItem = fetchResults?[0]
            XCTAssertTrue(todoItem?.title == originalItemTitle, "The item was  updated in the database")
            expect.fulfill()
        })
        
        self.waitForExpectations(timeout: 60, handler: nil)
    }
}



class CacheMockApiClient : MockApiClient {
    
    required init(baseURL:String!){
        super.init(baseURL: baseURL)
    }
    
    override func makeRequest(method: HTTPMethod, path: String!, parameters: [String : AnyObject]?) -> DataRequest {
        let stubs = NetworkCallStubs(host:"ec2-52-32-105-2.us-west-2.compute.amazonaws.com")
        stubs.stubRequests(path: "/all", responseObjectArray: stubs.severalItemTodoList)
        stubs.stubRequests(path: "/delete/10", responseObject: ["":""])
        stubs.stubRequests(path: "/delete/11", responseObject: ["":""],statusCode:500)
        stubs.stubRequests(path: "/update/15", responseObject: parameters!)
        stubs.stubRequests(path: "/update/16", responseObject:["":""], statusCode:404)
        if(parameters != nil && parameters?["id"] != nil){
    
            var params = parameters!
            if(params["id"] as! Int32 == -1){
                stubs.stubRequests(path:"/new",responseObject:["":""], statusCode:400)
            } else {
                params["id"] = params["id"] as! Int32 + Int32(1) as AnyObject
                stubs.stubRequests(path: "/new",responseObject:params)
            }
            
        }
        
        return Alamofire.request(super.path(path), method: method, parameters: parameters, headers: nil)
    }
}

