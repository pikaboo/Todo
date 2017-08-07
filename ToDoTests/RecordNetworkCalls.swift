//
//  RecordNetworkCalls.swift
//  ToDo
//
//  Created by admin on 8/6/17.
//  Copyright © 2017 admin. All rights reserved.
//

import XCTest
@testable import ToDo
@testable import AlamofireCoreData
@testable import Alamofire
import CoreData
import OHHTTPStubs
class RecordNetworkCalls: XCTestCase {
    
    var context : NSManagedObjectContext!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        context = CoreDataUnitTestHelper.setUpInMemoryManagedObjectContext()
    }
    
    override func tearDown() {
        OHHTTPStubs.removeAllStubs()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
//        let configuration = URLSessionConfiguration.default
//        configuration.httpAdditionalHeaders = ["":""]
//        
//        if let sharedRecorder = SWHttpTrafficRecorder.sharedRecorder() {
//            sharedRecorder.recordingFormat = SWHTTPTrafficRecordingFormat.BodyOnly
//            
//            sharedRecorder.startRecording(atPath:"responses",forSessionConfiguration:configuration)
//        }
//        
//        
//        
        let serverManager :ServerManager = ServerManager()
        let stubs = NetworkCallStubs(host:"ec2-52-32-105-2.us-west-2.compute.amazonaws.com")
        stubs.stubRequests(path: "/all", responseObjectArray: stubs.severalItemTodoList)
        let expect = expectation(description: "wait for requests to load")
        
        
        let dataRequest :DataRequest = serverManager.getAllItems()
        
        dataRequest.responseJSON { (response) in
          
        
        
            expect.fulfill()
        }
        
        self.waitForExpectations(timeout: 60, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
