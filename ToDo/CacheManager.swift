//
//  CacheManager.swift
//  ToDo
//
//  Created by admin on 8/3/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import AlamofireCoreData
import CoreData
public class CacheManager: NSObject {
    
    var serverManager : ServerManager!
    var context : NSManagedObjectContext!

    convenience init(serverManager: ServerManager, context:NSManagedObjectContext){
        self.init()
        self.context = context
        self.serverManager = serverManager
    }

    
    func getAllItems(completion : @escaping (_ items : [TodoItem]?) ->Void ) {
        
        let fetchReq : NSFetchRequest<TodoItem>  = TodoItem.fetchRequest()
        
        self.getAllItems(force: false, fetchRequest: fetchReq, completion: completion)
      
    }
    
    fileprivate func getAllItemsLocal(fetchRequest: NSFetchRequest<TodoItem> ,completion: @escaping (_ items : [TodoItem]?) -> Void) -> Bool{
        let todoItems = try? self.context.fetch(fetchRequest)
        if (todoItems?.count)! > 0 {
            completion(todoItems)
            return true
        }
        return false
    }
    fileprivate func getAllItemsFromServer(fetchRequest:NSFetchRequest<TodoItem>, completion: @escaping (_ items : [TodoItem]?) -> Void){
        self.serverManager.getAllItems().responseInsert(context: self.context, type: Many<TodoItem>.self) { response in
            switch(response.result){
            case .success(_):
                
                if(response.response?.statusCode != 200){
                    print("couldnt get items from the server")
                    completion([])
                    return
                }
                
                let insertedTodoItems = try? self.context.fetch(fetchRequest)
                
                completion(insertedTodoItems)
                
                break
            case .failure:
                // handle error
                completion([])
                break
            }
        }
    }
    
    func getAllItems(force:Bool! ,fetchRequest: NSFetchRequest<TodoItem>, completion: @escaping(_ items: [TodoItem]?) -> Void){
        if(force) {
            self.getAllItemsFromServer(fetchRequest:fetchRequest, completion: completion)
            return
        }
        
        let gotLocalItems = self.getAllItemsLocal(fetchRequest: fetchRequest, completion: completion)
        
        if(gotLocalItems){
            return
        }
        
        self.getAllItemsFromServer(fetchRequest:fetchRequest, completion:completion)
    }
    
    func deleteItem(item:TodoItem, completion: @escaping (_ error : Error?) ->Void){
        let itemId = item.id

        self.serverManager.deleteItem(itemId: Int32(itemId)).responseJSON { (response) in
            switch(response.result){
            case .success(_):
                if(response.response?.statusCode != 200){
                    let err = NSError(domain:"", code:-1, userInfo:["error" : "failed to delete item:\(itemId) from server"])
                    completion(err)
                    return
                }
                self.context.delete(item)
                try? self.context.save()
                
                
                completion(nil)
                break
            case .failure:
                let err = NSError(domain:"", code:-1, userInfo:["error" : "failed to delete item:\(itemId) from server"])
                completion(err)
                break
            }
           
        }
    }
    
    func createNewItem(item:TodoItem, completion:@escaping (_ err : Error?) -> Void){
        self.serverManager.createNewItem(item: item).responseJSON { (response) in
            if(response.response?.statusCode != 200){
                let err = NSError(domain:"", code:-1, userInfo:["error" : "failed to update item:\(item) in server"])
                completion(err)
                return
            }
            
            switch (response.result){
                case .success(_):
                    let updatedItem = response.result.value as! [String: AnyObject]
                    item.id = updatedItem["id"] as! Int32
                    if(self.context != item.managedObjectContext){
                        try? self.context.insert(item)
                        
                    }
            
                    try? self.context.save()
                    
                    let fetchReq : NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
                    
                    if let count = try? self.context.count(for: fetchReq){
                        if(count == 1){
                            completion(nil)
                            return
                        }else {
                            let err = NSError(domain:"", code:-1, userInfo:["error" : "failed to update item:\(item) in db"])
                            completion(err)
                        }
                    }
                break
            case .failure:
                let err = NSError(domain:"", code:-1, userInfo:["error" : "failed to update item:\(item) in server"])
                completion(err)
                return
                
            }
        }
    }
    
    func updateItem(item:TodoItem, completion:@escaping (_ err : Error?) -> Void){
        self.serverManager.updateItem(item: item).responseJSON { (response) in
            if(response.response?.statusCode != 200){
                let err = NSError(domain:"", code:-1, userInfo:["error" : "failed to update item:\(item) in server"])
                completion(err)
                return
            }

            switch (response.result){
            case .success(_):
                let updatedItem = response.result.value as! [String: AnyObject]
                let fetchReq : NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
                fetchReq.predicate = NSPredicate(format: "id = \(item.id)")
                
                if let fetchResults = try? self.context.fetch(fetchReq){
                    if(fetchResults.count != 0){
                        let managedObject = fetchResults[0]
                        let entity = managedObject.entity
                        let attributes = entity.attributesByName
                        for (attrKey, _) in attributes {
                            managedObject.setValue(updatedItem[attrKey] , forKey: attrKey)
                        }
                        try? self.context.save()
                        completion(nil)
                        return
                    }else {
                        let err = NSError(domain:"", code:-1, userInfo:["error" : "failed to update item:\(item) in db"])
                        completion(err)
                    }
                }
                break
            case .failure:
                let err = NSError(domain:"", code:-1, userInfo:["error" : "failed to update item:\(item) in server"])
                completion(err)
                return
                
            }
        }
    }

    
    
}


