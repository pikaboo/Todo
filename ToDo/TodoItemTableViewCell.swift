//
//  TodoItemTableViewCell.swift
//  ToDo
//
//  Created by Lena on 8/7/17.
//  Copyright © 2017 Lena. All rights reserved.
//

import UIKit

class TodoItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var completed: UISwitch!
    
    
    fileprivate var indexPath:IndexPath!
    var taskCompletionDelegate : TaskCompletion?
    
    
    
    func switchChanged(){
        self.taskCompletionDelegate?.onTaskCompleted(completed: self.completed.isOn, atIndex: self.indexPath)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.completed.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
    }

   
    
    func configureItem(item:TodoItem, indexPath:IndexPath){
        self.indexPath = indexPath
        self.idLabel.text = "\(item.id)"
        self.titleLabel.text = item.title
        self.completed.setOn(item.completed, animated: false)
    }
    
    deinit {
        if self.taskCompletionDelegate != nil {
            self.taskCompletionDelegate = nil
        }
    }
    
}

protocol TaskCompletion {
    func onTaskCompleted(completed : Bool, atIndex: IndexPath)
}
