//
//  TodoItem+CoreDataProperties.swift
//  
//
//  Created by Lena on 8/5/17.
//
//

import Foundation
import CoreData


extension TodoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoItem> {
        return NSFetchRequest<TodoItem>(entityName: "TodoItem")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var id: Int32
    @NSManaged public var title: String?

    public func toDictionary() -> [String:Any]{
        return ["completed":self.completed as AnyObject, "id":self.id as AnyObject, "title":self.title as AnyObject]
    }
    

    
    convenience init(context:NSManagedObjectContext ,title:String!, completed:Bool! = false, id:Int32 = 0){
        let entity = NSEntityDescription.entity(forEntityName:"TodoItem", in:context)
        self.init(entity: entity!, insertInto: context)
        self.title = title
        self.completed = completed
        self.id = id
    }
    
    convenience init(context: NSManagedObjectContext, itemDict:[String:Any]){
        self.init(context: context, title:itemDict["title"] as! String, completed:itemDict["completed"] as! Bool,id:itemDict["id"] as! Int32)
    }
    
    convenience init(context:NSManagedObjectContext, item:TodoItem){
        self.init(context:context,itemDict: item.toDictionary())
    }
}
