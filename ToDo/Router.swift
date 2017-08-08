//
//  Router.swift
//  ToDo
//
//  Created by Lena on 8/7/17.
//  Copyright © 2017 Lena. All rights reserved.
//

import UIKit

class Router: NSObject {

    
    fileprivate func showScreen(from:UIViewController, identifier:String, params:Any?){
        if let src = from as? ViewController {
            src.performSegue(withIdentifier: identifier, sender: params)
        }
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination
        if  let todoItemDetail = dest as? TodoItemDetailViewController  {
            todoItemDetail.todoItem = sender as! TodoItem
        }
        
    }
    
    func showItemDetail(from:UIViewController,todoItem: TodoItem){
        self.showScreen(from:from, identifier:"itemDetail",params:todoItem)
    }
    
    func showCreateItem(from:UIViewController){
         self.showScreen(from:from, identifier:"createItem",params:nil)
    }
}
