//
//  NetworkCallStubs.swift
//  ToDo
//
//  Created by Lena on 8/6/17.
//  Copyright © 2017 Lena. All rights reserved.
//

import UIKit
import OHHTTPStubs
class NetworkCallStubs: NSObject {

    
    var host :String!
    
    convenience init(host:String!){
        self.init()
        self.host = host
    }
    
  
    func stubRequests(path:String!, responseObjectArray:[[String:Any]]){
        stub(condition: isHost(self.host) && isPath(path)) {
            _ in
            
            return OHHTTPStubsResponse(jsonObject:responseObjectArray, statusCode:200, headers:nil)
        }
    }
    func stubRequests(path:String!, responseObject:[String:Any]){
        self.stubRequests(path: path, responseObject: responseObject, statusCode: 200)
    }
    
    func stubRequests(path:String!, responseObject:[String:Any], statusCode:Int32){
        stub(condition: isHost(self.host) && isPath(path)) {
            _ in
            
            return OHHTTPStubsResponse(jsonObject:responseObject, statusCode:statusCode, headers:nil)
        }
    }
}
