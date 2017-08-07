//
//  TodoItem+CoreDataProperties.swift
//  
//
//  Created by admin on 8/5/17.
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

    public func toDictionary() -> [String:AnyObject]{
        return ["completed":self.completed as AnyObject, "id":self.id as AnyObject, "title":self.title as AnyObject]
    }
    
    public class func fromDictionary(_ dict : [String: AnyObject]) ->TodoItem{
        let todoItem = TodoItem()
        todoItem.id = dict["id"] as! Int32
        todoItem.completed = (dict["completed"] != nil)
        todoItem.title = dict["title"] as? String
        return todoItem
    }
}
