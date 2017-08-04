//
//  ToDoTests.swift
//  ToDoTests
//
//  Created by admin on 8/3/17.
//  Copyright © 2017 admin. All rights reserved.
//

import XCTest
@testable import ToDo

class ToDoTests: XCTestCase {
    
    
    var serverManager: ServerManager!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.serverManager = ServerManager()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let e = expectation(description:"get todo items")
     //   self.serverManager.makeRequest()
        self.waitForExpectations(timeout:60,handler:nil)
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
