//
//  TodoItemDataSource.swift
//  ToDo
//
//  Created by Lena on 8/7/17.
//  Copyright © 2017 Lena. All rights reserved.
//

import UIKit

class TodoItemDataSource: NSObject, UITableViewDataSource, TaskCompletion {

    var cacheManager : CacheManager!
    var allItems : [TodoItem]!
    
    convenience init(cacheManager: CacheManager, allItems:[TodoItem]!) {
        self.init()
        self.cacheManager = cacheManager
        self.allItems = allItems
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = allItems.count
        return count
        
    }
    
    fileprivate func refreshData(completion:@escaping ()->Void){
        self.cacheManager.getAllItems(force: false, fetchRequest: cacheManager.sortedFetchRequest()) { (items) in
            self.allItems.removeAll()
            for item in items! {
                self.allItems.append(item)
            }
            completion()
          
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todoItem = self.allItems[indexPath.row]
        let tableCell :TodoItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TodoItemIdentifier", for: indexPath) as! TodoItemTableViewCell
        tableCell.configureItem(item: todoItem,indexPath: indexPath)
        tableCell.taskCompletionDelegate = self
        return tableCell
        
    }
    
    func createItem(_ tableView: UITableView, item:[String:Any]){
        self.cacheManager.createNewItem(item: item) { (err) in
            self.refreshData() {
                tableView.reloadData()
            }
        }
    }
    
    func updateItem(_ tableView: UITableView, item:[String:Any]){

        self.cacheManager.updateItem(item: item) { (err) in
            self.refreshData(){
                tableView.reloadData()
            }
        }
    }
    
    func onTaskCompleted(completed: Bool, atIndex: IndexPath) {
        let todoItem = self.allItems[atIndex.row]
        var todoItemDict = todoItem.toDictionary()
        todoItemDict["completed"] = completed
        self.cacheManager.updateItem(item: todoItemDict) { (err) in
            
        }
    }
    
    func deleteItem(_ tableView: UITableView, item:[String:Any]){
        self.cacheManager.deleteItem(item: item) { (err) in
            self.refreshData(){
                tableView.reloadData()
            }
        }
    }
    
    func itemById(itemId : Int) -> TodoItem? {
        return self.cacheManager.itemById(itemId:Int32(itemId))
    }
    
}
