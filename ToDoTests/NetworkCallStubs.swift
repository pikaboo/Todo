//
//  NetworkCallStubs.swift
//  ToDo
//
//  Created by admin on 8/6/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import OHHTTPStubs
class NetworkCallStubs: NSObject {

    
    var host :String!
    
    convenience init(host:String!){
        self.init()
        self.host = host
    }
    
    let emptyTodoList : [[String:AnyObject]] = []
    let oneItemTodo :[String: Any] = ["title":"one" ,"completed":false, "id":1]
    let oneItemTodoList :[[String:Any]] = [["title":"one" ,"completed":false, "id":1]]
    let severalItemTodoList : [[String:Any]] = [["title":"item1","completed":false,"id":1], ["title":"item2","completed":true,"id":2]]
    
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
