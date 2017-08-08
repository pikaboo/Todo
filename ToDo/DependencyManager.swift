//
//  DependencyManager.swift
//  ToDo
//
//  Created by Lena on 8/7/17.
//  Copyright © 2017 Lena. All rights reserved.
//

import UIKit
import CoreData
class DependencyManager: NSObject {

    
    fileprivate var client : ClientProtocol!
    fileprivate var serverManager : ServerManager!
    fileprivate var managedObjectContext: NSManagedObjectContext!
    var cacheManager : CacheManager!
    fileprivate var baseURL : String! = "http://ec2-52-32-105-2.us-west-2.compute.amazonaws.com"
    fileprivate var port : String! = "8080"
    
    var router: Router!
    
    override init(){
        self.client = Client(baseURL: "\(self.baseURL!):\(self.port!)")
        self.serverManager = ServerManager(client:self.client)
        self.managedObjectContext = Storage.shared.context
        self.cacheManager = CacheManager(serverManager:self.serverManager, context:self.managedObjectContext)
        self.router = Router()
        
    }
    
    func createDataSource(completion: @escaping (_ dataSource :UITableViewDataSource) -> Void){
        self.cacheManager.getAllItems(force:true, fetchRequest: self.cacheManager.sortedFetchRequest()){
            items in
            let dataSource : TodoItemDataSource = TodoItemDataSource(cacheManager:self.cacheManager, allItems:items)
            completion(dataSource)
        }
    }
}
