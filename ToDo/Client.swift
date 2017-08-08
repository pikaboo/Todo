//
//  Client.swift
//  ToDo
//
//  Created by Lena on 8/3/17.
//  Copyright © 2017 Lena. All rights reserved.
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
    
    public func makeRequest(method:HTTPMethod,path:String!,parameters:[String:Any]? = ["":""]) ->DataRequest{
        let url = self.path(path)!
        
        var params : [String: Any] = ["":""]
        if parameters != nil {
            params = parameters!
        }
        print("sending  request to url:\(url) method: \(method) parameters:\(String(describing: params))")
        var encoding : ParameterEncoding =  JSONEncoding.default
        
        if method == .get {
            encoding = URLEncoding.default
        }
        let dataRequest :DataRequest = Alamofire.request(url, method:method,parameters:params,encoding:encoding,  headers: nil)
        
        return dataRequest
    }
    
    
}
