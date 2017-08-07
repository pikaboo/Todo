//
//  ServerManagerTests.swift
//  ToDo
//
//  Created by admin on 8/3/17.
//  Copyright © 2017 admin. All rights reserved.
//

import XCTest
import Foundation
import CoreData
@testable import ToDo
@testable import Alamofire
import OHHTTPStubs
class ServerManagerTests: XCTestCase {

    var serverManager: ServerManager!
    var client : ClientProtocol = MockApiClient(baseURL:"MockApiClientBaseURL")
    var managedObjectContext :NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        
        self.managedObjectContext = CoreDataUnitTestHelper.setUpInMemoryManagedObjectContext()
        self.serverManager = ServerManager(client:self.client)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        OHHTTPStubs.removeAllStubs()
        super.tearDown()
    }
    
    func testGetAllItemsRequestIsFormedCorrectly() {
        
        let dataRequest :   DataRequest = self.serverManager.getAllItems()
        
        
        XCTAssertTrue(dataRequest.request?.httpMethod == "GET")
        XCTAssertTrue((dataRequest.request?.url?.absoluteString.contains("/all"))!)
        
    }
    
    func testCreateItem(){
        let todoItem = TodoItem(context:self.managedObjectContext, title:"Lena",completed:false, id:0)
        let dataRequest : DataRequest = self.serverManager.createNewItem(item:todoItem)
        let todoItemDict = todoItem.toDictionary()
        
        XCTAssertTrue(dataRequest.request?.httpMethod == "POST")
        XCTAssertTrue((dataRequest.request?.url?.absoluteString.contains("/new"))!)
        XCTAssertTrue(self.checkParametersAreEqual(dataRequest: dataRequest, expectedParameters: todoItemDict))
      
 
        
    }
    
    func testUpdateItem(){
        let itemId = 10
        let todoItem = TodoItem(context:self.managedObjectContext, title:"Lena",completed:false, id:Int32(itemId))
        let dataRequest : DataRequest = self.serverManager.updateItem(item:todoItem)
        let todoItemDict = todoItem.toDictionary()
        
        XCTAssertTrue(dataRequest.request?.httpMethod == "PUT")
        XCTAssertTrue((dataRequest.request?.url?.absoluteString.contains("/update/\(itemId)"))!)
        XCTAssertTrue(self.checkParametersAreEqual(dataRequest: dataRequest, expectedParameters: todoItemDict))
    }
    
    
    func testDeleteItem(){
        let itemId = 10

        let dataRequest : DataRequest = self.serverManager.deleteItem(itemId:Int32(itemId))
        
        XCTAssertTrue(dataRequest.request?.httpMethod == "DELETE")
        XCTAssertTrue((dataRequest.request?.url?.absoluteString.contains("/delete/\(itemId)"))!)
    }
    
    func checkParametersAreEqual(dataRequest:DataRequest, expectedParameters:[String:AnyObject]) -> Bool {
        
        
        let parametersInRequest = String(data:(dataRequest.request?.httpBody)!, encoding:.utf8)
        
        
        for (key,value) in expectedParameters {
            if( !(parametersInRequest?.contains("\(key)=\(value)"))!){
                return false
            }
        }
        
        return true
    }
    

}

extension TodoItem {
    convenience init(context:NSManagedObjectContext ,title:String!, completed:Bool! = false, id:Int32 = 0){
        let entity = NSEntityDescription.entity(forEntityName:"TodoItem", in:context)
        self.init(entity: entity!, insertInto: context)
        self.title = title
        self.completed = completed
        self.id = id
    }
}



