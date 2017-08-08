//
//  ClientProtocol.swift
//  ToDo
//
//  Created by Lena on 8/3/17.
//  Copyright © 2017 Lena. All rights reserved.
//

import UIKit
import Alamofire
public protocol ClientProtocol{
     var baseURL : String! { get set }
    
    
    init?(baseURL: String!)
    
     func path(_ urlPath: String!)->String!
    
     func makeRequest(method:HTTPMethod,path:String!)->DataRequest
    
     func makeRequest(method:HTTPMethod,path:String!,parameters:[String:Any]?) ->DataRequest
}

