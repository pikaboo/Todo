//
//  CacheManager.swift
//  ToDo
//
//  Created by Lena on 8/3/17.
//  Copyright © 2017 Lena. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
public class CacheManager: NSObject {
    
    var serverManager : ServerManager!
    var context : NSManagedObjectContext!

    convenience init(serverManager: ServerManager, context:NSManagedObjectContext){
        self.init()
        self.context = context
        self.serverManager = serverManager
    }

    func sortingDescriptors() -> [NSSortDescriptor]{
        let sortDescriptorCompleted = NSSortDescriptor(key: "completed", ascending: false)
        let sortDescriptorId = NSSortDescriptor(key: "id", ascending: true)
        let sortDescriptors = [sortDescriptorCompleted,sortDescriptorId]
        return sortDescriptors
    }
    
    func sortedFetchRequest () ->NSFetchRequest<TodoItem> {
        let fetchReq : NSFetchRequest<TodoItem>  = TodoItem.fetchRequest()
        fetchReq.sortDescriptors = self.sortingDescriptors()
        return fetchReq
    }
    func getAllItems(completion : @escaping (_ items : [TodoItem]?) ->Void ) {
        
        let fetchReq : NSFetchRequest<TodoItem>  = TodoItem.fetchRequest()
        
        fetchReq.sortDescriptors = self.sortingDescriptors()
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
        self.serverManager.getAllItems().responseJSON(completionHandler: { (response) in
            switch(response.result){
            case .success(_):
                
                if(response.response?.statusCode != 200){
                    print("couldnt get items from the server")
                    completion([])
                    return
                }
                let items = response.result.value as! [[String:AnyObject]]
                for item in items {
                    let itemById = self.itemById(itemId: item.getId())
                    if itemById != nil {
                        continue
                    }
                    
                    _ = TodoItem(context:self.context,itemDict:item)
                }
                
                try? self.context.save()
                
                let insertedTodoItems = try? self.context.fetch(fetchRequest)
                
                completion(insertedTodoItems)
                
                break
            case .failure:
                // handle error
                completion([])
                break
            }
        })
    
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
    
    func deleteItem(item:[String:Any], completion: @escaping (_ error : Error?) ->Void){
        let itemId = item.getId()
        self.serverManager.deleteItem(itemId: itemId).response { (response) in

                if(response.response?.statusCode != 200){
                    let err = NSError(domain:"", code:-1, userInfo:["error" : "failed to delete item:\(itemId) from server"])
                    completion(err)
                    return
                }
                let item = self.itemById(itemId: itemId)
                self.context.delete(item!)
                try? self.context.save()
                
                
                completion(nil)
           
        }
    }
    
    
  
    func createNewItem(item:[String:Any], completion:@escaping (_ err : Error?) -> Void){
        self.serverManager.createNewItem(item: item).responseJSON { (response) in
            if(response.response?.statusCode != 200){
                let err = NSError(domain:"", code:-1, userInfo:["error" : "failed to update item:\(item) in server"])
                completion(err)
                return
            }
            
            switch (response.result){
            case .success(_):
                let updatedItem = response.result.value as! [String: AnyObject]
                
                _ = TodoItem(context:self.context,itemDict:updatedItem)
                
                try? self.context.save()
                
                let itemById = self.itemById(itemId: updatedItem.getId())
                
                    if itemById != nil {
                        completion(nil)
                        return
                    }else {
                        let err = NSError(domain:"", code:-1, userInfo:["error" : "failed to update item:\(item) in db"])
                        completion(err)
                    }
                
                break
            case .failure:
                let err = NSError(domain:"", code:-1, userInfo:["error" : "failed to update item:\(item) in server"])
                completion(err)
                return
                
            }
        }
    }
    
    func updateItem(item:[String:Any], completion:@escaping (_ err : Error?) -> Void){
        self.serverManager.updateItem(item: item).responseJSON { (response) in
            if(response.response?.statusCode != 200){
                let err = NSError(domain:"", code:-1, userInfo:["error" : "failed to update item:\(item) in server"])
                completion(err)
                return
            }

            switch (response.result){
            case .success(_):
                let updatedItem = response.result.value as! [String: AnyObject]
                let itemId = updatedItem.getId()
                let managedObject = self.itemById(itemId: itemId)
                
                if managedObject != nil{
                    
                        let entity = managedObject?.entity
                        let attributes = entity?.attributesByName
                        for (attrKey, _) in attributes! {
                            managedObject?.setValue(updatedItem[attrKey] , forKey: attrKey)
                        }
                        try? self.context.save()
                        completion(nil)
                        return
                    }else {
                        let err = NSError(domain:"", code:-1, userInfo:["error" : "failed to update item:\(item) in db"])
                        completion(err)
                    }
                
                break
            case .failure:
                let err = NSError(domain:"", code:-1, userInfo:["error" : "failed to update item:\(item) in server"])
                completion(err)
                return
                
            }
        }
    }

    func itemById(itemId:Int32) ->TodoItem? {
        let fetchReq : NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        fetchReq.predicate = NSPredicate(format: "id = \(itemId)")
        
        if let fetchResults = try? self.context.fetch(fetchReq){
            if(fetchResults.count == 0){
                return nil
            }
            return fetchResults[0]
        }
        return nil
    }
    
}


