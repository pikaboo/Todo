//
//  ServerManager.swift
//  ToDo
//
//  Created by Lena on 8/3/17.
//  Copyright © 2017 Lena. All rights reserved.
//

import UIKit
import Alamofire

public class ServerManager: NSObject {
    
    
    
    var apiClient: ClientProtocol!

    public init (client: ClientProtocol){

        self.apiClient = client
    }
    
    public func getAllItems() -> DataRequest {
        return self.apiClient.makeRequest(method: .get, path: "all")
    }
    
    public func createNewItem(item:[String:Any]) ->DataRequest {
        return self.apiClient.makeRequest(method:.post,path:"new",parameters:item)
    }
    
    public func updateItem(item: [String:Any]) ->DataRequest {
        return self.apiClient.makeRequest(method:.put,path:"update/\(item.getId())",parameters:item)
    }
    public func deleteItem(itemId: Int32) ->DataRequest {
        
        return self.apiClient.makeRequest(method:.delete,path:"delete/\(itemId)")
    }
}

