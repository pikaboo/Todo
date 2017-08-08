//
//  ClientTests.swift
//  ToDo
//
//  Created by Lena on 8/3/17.
//  Copyright © 2017 Lena. All rights reserved.
//

import XCTest
@testable import ToDo
@testable import Alamofire
class ClientTests: XCTestCase {

    
    var testBaseURL = "https://httpbin.org"
    
    var client : Client!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.client = Client(baseURL:self.testBaseURL)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testbaseURLWasSet(){
        XCTAssertTrue(self.client.baseURL == self.testBaseURL)
    }
    
    func testPath(){
        let path = "get"
        let expectedResult = "\(self.client.baseURL!)/\(path)"
        XCTAssertTrue(self.client.path(path) == expectedResult)
    }
    
    func makeRequest(method:HTTPMethod, path:String!){
        let expect = expectation(description:"Wait for request \(path) to finish")
        
        self.client.makeRequest(method: method , path: path).response { response in
            if response.response?.statusCode == 200 {
                expect.fulfill()
            }
        }
        
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testCanMakeGetRequest(){
        self.makeRequest(method:.get,path:"get")
    }
    
    func testCanMakePostRequest(){
        self.makeRequest(method:.post, path:"post")
    }
    
    func testCanMakePutRequest(){
        self.makeRequest(method:.put, path:"put")
    }
    
    func testCanMakeDeleteRequest(){
        self.makeRequest(method:.delete,path:"delete")
    }
    

}
