//
//  Dictionary+Todo.swift
//  ToDo
//
//  Created by Lena on 8/8/17.
//  Copyright © 2017 Lena. All rights reserved.
//

import UIKit

extension Dictionary where Key : CustomStringConvertible, Value : Any{
    
    func getId() -> Int32{
        let id = self.get("id")
        
        if id == nil {
            return Int32(0)
        }
        
        let idNumber : NSNumber = id as! NSNumber
        
        return idNumber.int32Value
    }
    
    func getCompleted() -> Bool {
        let completed = self.get("completed")
        if completed == nil {
            return false
        }
        let idNumber : NSNumber = completed as! NSNumber
        
        return idNumber.boolValue
    }
    
    func getTitle() -> String {
        let title = self.get("title")
        
        if title == nil {
            return ""
        }
        
        return title as! String
    }
    
    fileprivate func get(_ stringKey : String!) -> Any?{
        for key in self.keys {
            if key.description == stringKey {
                return self[key]!
            }
        }
        return nil
    }
}
