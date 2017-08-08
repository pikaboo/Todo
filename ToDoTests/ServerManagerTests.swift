//
//  ServerManagerTests.swift
//  ToDo
//
//  Created by Lena on 8/3/17.
//  Copyright © 2017 Lena. All rights reserved.
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
        let todoItemDict = todoItem.toDictionary()
        let dataRequest : DataRequest = self.serverManager.createNewItem(item:todoItemDict)
        
        
        XCTAssertTrue(dataRequest.request?.httpMethod == "POST")
        XCTAssertTrue((dataRequest.request?.url?.absoluteString.contains("/new"))!)
        XCTAssertTrue(self.checkParametersAreEqual(dataRequest: dataRequest, expectedParameters: todoItemDict))
      
 
        
    }
    
    func testUpdateItem(){
        let itemId = 10
        let todoItem = TodoItem(context:self.managedObjectContext, title:"Lena",completed:false, id:Int32(itemId))
        let todoItemDict = todoItem.toDictionary()
        let dataRequest : DataRequest = self.serverManager.updateItem(item:todoItemDict)
        
        
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
    
    func checkParametersAreEqual(dataRequest:DataRequest, expectedParameters:[String:Any]) -> Bool {
        
        
        let parametersInRequest :[String:Any] = try! JSONSerialization.jsonObject(with: (dataRequest.request?.httpBody)!, options:.allowFragments) as! [String : Any]
        
    
        return NSDictionary(dictionary:expectedParameters).isEqual(to:NSDictionary(dictionary:parametersInRequest) as! [AnyHashable : Any])
        
    }
    

}



