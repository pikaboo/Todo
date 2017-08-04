//
//  ServerManager.swift
//  ToDo
//
//  Created by admin on 8/3/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Alamofire

public class ServerManager: NSObject {
    
    
    var baseURL : String! = "http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com:8080"
    var apiClient: ClientProtocol!
    
    public override init(){
        self.apiClient = Client(baseURL: self.baseURL)
    }
    
    public init (client: ClientProtocol){
        self.apiClient = client
    }
    
    public func getAllItems() -> DataRequest {
        return self.apiClient.makeRequest(method: .get, path: "all")
    }
    
    public func createNewItem(item:TodoItem) ->DataRequest {
        let dict = item.toDictionary()
        return self.apiClient.makeRequest(method:.post,path:"new",parameters:dict)
    }
    
    public func updateItem(item: TodoItem) ->DataRequest {
        let dict = item.toDictionary()
        return self.apiClient.makeRequest(method:.post,path:"update/\(item.id)",parameters:dict)
    }
    public func deleteItem(itemId: Int32) ->DataRequest {
        
        return self.apiClient.makeRequest(method:.post,path:"update/\(itemId)")
    }
}

