//
//  CreateItemViewController.swift
//  ToDo
//
//  Created by Lena on 8/7/17.
//  Copyright © 2017 Lena. All rights reserved.
//

import UIKit

class CreateItemViewController: NavigationButtonController {

    
    @IBOutlet weak var todoItemDetailView: TodoItemDetailView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showButtons(buttons: [.save])
        
        self.navigationItem.title = "Create Todo Item"
    }
    
    override func saveButtonClicked() {
        let itemData = self.todoItemDetailView.getItemData()
        
        NotificationCenter.default.post(name: CreateButtonClicked, object: nil, userInfo: itemData)
    }

}
