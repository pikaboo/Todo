//
//  Client.swift
//  ToDo
//
//  Created by admin on 8/3/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Alamofire
public class Client: NSObject, ClientProtocol {

    
    public var baseURL : String! = ""
    
    
    public required init(baseURL: String!){
        self.baseURL = baseURL
    }
    
    public func path(_ urlPath: String!)->String!{
        return "\(self.baseURL!)/\(urlPath!)"
    }
    
    public func makeRequest(method:HTTPMethod,path:String!)->DataRequest{
        return makeRequest(method:method,path:path,parameters:nil)
    }
    
    public func makeRequest(method:HTTPMethod,path:String!,parameters:[String:AnyObject]? = ["":"" as AnyObject]) ->DataRequest{
        return Alamofire.request(self.path(path), method:method, parameters:parameters, headers: nil)
    }
}
