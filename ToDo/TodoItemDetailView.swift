//
//  TodoItemDetailView.swift
//  ToDo
//
//  Created by Lena on 8/7/17.
//  Copyright © 2017 Lena. All rights reserved.
//

import UIKit

class TodoItemDetailView: UIView {

    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var completedLabel: UILabel!
    
    @IBOutlet weak var idTextLabel: UILabel!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var completedSwitch: UISwitch!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
       let topViews = Bundle.main.loadNibNamed("TodoItemDetailView", owner: self, options: nil)
        let topView :UIView = topViews!.first as! UIView
        topView.frame = self.bounds
        self.addSubview(topView)
        self.idTextLabel.text = ""
        self.titleTextField.text = ""
        self.completedSwitch.setOn(false, animated: false)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awake from nib")
        
    }
    
    
    
    func setItemData(item:TodoItem? ){
       
        if item == nil{
            return
        }
        self.idTextLabel.text = "\((item?.id)!)"
        self.titleTextField.text = item?.title
        self.completedSwitch.setOn((item?.completed)!, animated: false)
    }
    
    func getItemData() -> [String:Any]{
        let idText = idTextLabel.text!
        
        let idNumber = idText.characters.count > 0 ? Int(idText) : 0
        let id = idNumber
        let title = self.titleTextField.text!
        let completed = self.completedSwitch.isOn
        
        let itemData : [String:Any] = ["id" : id!, "title":title, "completed":completed ] 
        return itemData
    }
}
