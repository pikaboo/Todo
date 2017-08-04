//
//  ServerManagerTests.swift
//  ToDo
//
//  Created by admin on 8/3/17.
//  Copyright © 2017 admin. All rights reserved.
//

import XCTest
import Foundation
@testable import ToDo
@testable import Alamofire
class ServerManagerTests: XCTestCase {

    var serverManager: ServerManager!
    var client : ClientProtocol = MockApiClient(baseURL:"MockApiClientBaseURL")
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.serverManager = ServerManager(client:self.client)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetAllItemsRequestIsFormedCorrectly() {
        
        let dataRequest :   DataRequest = self.serverManager.getAllItems()
        
        
        XCTAssertTrue(dataRequest.request?.httpMethod == "GET")
        XCTAssertTrue((dataRequest.request?.url?.absoluteString.contains("/all"))!)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    

}

class MockApiClient : ClientProtocol {
    var result : DataResponse<Any>!
    var baseURL : String! = "MockApiClientBaseURL"
    
    required init(baseURL: String!){
        self.baseURL = baseURL
    }
    public func path(_ urlPath: String!)->String!{
        return "\(self.baseURL!)/\(urlPath!)"
    }
    
    func makeRequest(method:HTTPMethod,path:String!)->DataRequest {
        return makeRequest(method: method, path: path, parameters: ["" : "" as AnyObject])
    }
    
     func makeRequest(method: HTTPMethod, path: String!, parameters: [String : AnyObject]?) -> DataRequest {
        
        var request = try?  URLRequest(url: URL(string:self.path(path))!, method: HTTPMethod(rawValue: method.rawValue)!)
        request?.httpBody =  NSKeyedArchiver.archivedData(withRootObject: parameters!)
         let originalTask = DataRequest.Requestable(urlRequest: request!)
        let requestTask  = Request.RequestTask.data(originalTask,nil)
        
        let session : URLSession = URLSession()
            let resultingRequest = DataRequest(session: session, requestTask: requestTask, error: nil)
        

        return resultingRequest
    }
}
