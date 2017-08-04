//
//  TodoItem+CoreDataProperties.swift
//  
//
//  Created by admin on 8/3/17.
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
    
    

}
