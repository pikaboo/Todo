//
//  MockApiClient.swift
//  ToDo
//
//  Created by Lena on 8/6/17.
//  Copyright © 2017 Lena. All rights reserved.
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
        return makeRequest(method: method, path: path, parameters: ["" : "" as Any])
    }
    
    func makeRequest(method: HTTPMethod, path: String!, parameters: [String : Any]?) -> DataRequest {
        

        let stubs = NetworkCallStubs(host:self.baseURL)
        stubs.stubRequests(path: path, responseObject: ["":""])
        var encoding =  JSONEncoding.default
        
        if method == .get {
            encoding = JSONEncoding.default
        }
        return Alamofire.request(self.path(path), method: method,parameters: parameters,encoding:encoding,  headers: nil)
    }
    

}


