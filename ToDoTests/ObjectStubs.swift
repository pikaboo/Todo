//
//  ObjectStubs.swift
//  ToDo
//
//  Created by Lena on 8/7/17.
//  Copyright © 2017 Lena. All rights reserved.
//

import UIKit

class ObjectStubs: NSObject {
    
    static var shared  = ObjectStubs()
    
    let emptyTodoList : [[String:Any]] = []
    let oneItemTodo :[String: Any] = ["title":"one" ,"completed":false, "id":1]
    let oneItemTodoList :[[String:Any]] = [["title":"one" ,"completed":false, "id":1]]
    let severalItemTodoList : [[String:Any]] = [["title":"item1","completed":false,"id":1], ["title":"item2","completed":true,"id":2]]
    let emptyTodoItem : [String:Any] = ["":""]
}
