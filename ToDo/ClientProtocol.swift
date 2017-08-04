//
//  ClientProtocol.swift
//  ToDo
//
//  Created by admin on 8/3/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Alamofire
public protocol ClientProtocol{
     var baseURL : String! { get set }
    
    
    init?(baseURL: String!)
    
     func path(_ urlPath: String!)->String!
    
     func makeRequest(method:HTTPMethod,path:String!)->DataRequest
    
     func makeRequest(method:HTTPMethod,path:String!,parameters:[String:AnyObject]?) ->DataRequest
}
