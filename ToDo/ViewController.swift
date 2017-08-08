//
//  ViewController.swift
//  ToDo
//
//  Created by Lena on 8/3/17.
//  Copyright © 2017 Lena. All rights reserved.
//

import UIKit

class ViewController: NavigationButtonController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var dataSource:TodoItemDataSource!
    var dependencyManager: DependencyManager!
    var router :Router!
    var observers : [NSObjectProtocol] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dependencyManager = DependencyManager()
        self.dependencyManager.createDataSource { (dataSource) in
            self.dataSource = dataSource as! TodoItemDataSource
            let nib = UINib(nibName: "TodoItemTableViewCell", bundle: Bundle.main)
            self.tableView.register(nib, forCellReuseIdentifier: "TodoItemIdentifier")
            
            self.tableView.dataSource = self.dataSource
            self.tableView.delegate = self
            self.tableView.reloadData()
        }
        
        self.showButtons(buttons: [.create])
        self.router = self.dependencyManager.router
        
        self.navigationItem.title = "Todo Items"
        
        let saveToken : NSObjectProtocol = NotificationCenter.default.addObserver(forName: SaveButtonClicked, object: nil, queue: OperationQueue.main) { (note) in
            let itemData = note.userInfo as! [String :AnyObject]
            self.dataSource.updateItem(self.tableView, item: itemData)
            self.navigationController?.popViewController(animated: true)
            
        }
        
        let deleteToken : NSObjectProtocol = NotificationCenter.default.addObserver(forName: DeleteButtonClicked, object: nil, queue: OperationQueue.main) { (note) in
            let itemData = note.userInfo as! [String :Any]
            self.dataSource.deleteItem(self.tableView, item: itemData)
            self.navigationController?.popViewController(animated: true)
        }
        
        let createToken : NSObjectProtocol = NotificationCenter.default.addObserver(forName: CreateButtonClicked, object: nil, queue: OperationQueue.main) { (note) in
            let itemData = note.userInfo as! [String : Any]
            self.dataSource.createItem(self.tableView,item:itemData)
            self.navigationController?.popViewController(animated: true)
            
        }

            self.observers = [saveToken, deleteToken, createToken]

        
    }
    
  
    
    deinit {
        for observer in observers {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataSource = tableView.dataSource as! TodoItemDataSource
        let todoItem :TodoItem = dataSource.allItems[indexPath.row]
        self.router.showItemDetail(from: self, todoItem: todoItem)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.router.prepare(for: segue, sender: sender)
    }
    
    override func addButtonClicked(){
        self.router.showCreateItem(from: self)
    }


}

