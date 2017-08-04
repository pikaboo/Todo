//
//  TodoItem.swift
//  ToDo
//
//  Created by admin on 8/3/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

extension TodoItem{
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
