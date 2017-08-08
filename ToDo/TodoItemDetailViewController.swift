//
//  TodoItemDetail.swift
//  ToDo
//
//  Created by Lena on 8/7/17.
//  Copyright © 2017 Lena. All rights reserved.
//

import UIKit
import CoreData
class TodoItemDetailViewController: NavigationButtonController {
    
    var todoItem : TodoItem?
    
    
    @IBOutlet weak var todoItemDetailView: TodoItemDetailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.todoItemDetailView.setItemData(item: self.todoItem)
        
        self.showButtons(buttons:[.save,.delete])
        
        self.navigationItem.title = "Todo Item Details"
    }
 
    
    override func saveButtonClicked() {
        let itemData = self.todoItemDetailView.getItemData()
        
        NotificationCenter.default.post(name: SaveButtonClicked, object: nil, userInfo: itemData)
    }
    
    override func deleteButtonClicked() {
        let itemData = self.todoItemDetailView.getItemData()
        
        NotificationCenter.default.post(name: DeleteButtonClicked, object: nil, userInfo: itemData)
    }
    
}
