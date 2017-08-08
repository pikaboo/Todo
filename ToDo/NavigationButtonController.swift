//
//  NavigationButtonController.swift
//  ToDo
//
//  Created by Lena on 8/7/17.
//  Copyright © 2017 Lena. All rights reserved.
//

import UIKit

class NavigationButtonController: BaseViewController {

    
    let SaveButtonClicked = NSNotification.Name(rawValue: "SaveButtonClicked")
    let DeleteButtonClicked = NSNotification.Name(rawValue: "DeleteButtonClicked")
    let CreateButtonClicked = NSNotification.Name(rawValue: "CreateButtonClicked")
    
    enum NavigationButtons{
        case save
        case delete
        case create
    }
    
    lazy var saveButton :UIBarButtonItem = {
       return  UIBarButtonItem( barButtonSystemItem: .save, target: self, action: #selector(saveButtonClicked))
    }()
    
    lazy var deleteButton : UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonClicked))
    }()
    lazy var createButton : UIBarButtonItem = {
       return  UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
    }()
    
    func saveButtonClicked(){
        
    }
    
    func deleteButtonClicked(){
    }
    
    func addButtonClicked(){
    }
    
    func showButtons(buttons:[NavigationButtons]){
        var barButtons: [UIBarButtonItem]! = []
        for button in buttons {
            switch button{
            case .save:
                barButtons.append(self.saveButton)
                break
            case .delete:
                barButtons.append(self.deleteButton)
                break
            case .create:
                barButtons.append(self.createButton)
                break
            }
        }
        self.navigationItem.rightBarButtonItems = barButtons
    }

}
