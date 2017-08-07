//
//  MockApiClient.swift
//  ToDo
//
//  Created by admin on 8/6/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
@testable import Alamofire
@testable import ToDo
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
        

        let stubs = NetworkCallStubs(host:self.baseURL)
        stubs.stubRequests(path: path, responseObject: ["":""])
        
        return Alamofire.request(self.path(path), method: method, parameters: parameters, headers: nil)
    }
    

}


