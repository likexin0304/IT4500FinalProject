//
//  ChoreEditViewController.swift
//  RoommatesToDo
//
//  Created by Kexin Li on 2017/12/7.
//  Copyright © 2017年 Anson. All rights reserved.
//

import UIKit

class ExpenseEditViewController: UITableViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var repeatPickerView: UIPickerView!
    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var costLabel: UITextField!
    
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    public var task:Task?
    
    @IBOutlet weak var highPrioritySwitch: UISwitch!
    
    let repeatTitles:[Repeat] = [.NoRepeat,.Weekly,.Monthly]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        title = "Expenses Edit"
        // Do any additional setup after loading the view.
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(clickDone(item:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        self.datePickerView.date = task?.dueDay ?? Date()
        self.titleTextField.text = task?.title
        
        if let `repeat` = task?.`repeat`{
            self.repeatPickerView.selectRow(repeatTitles.index(of: `repeat`)!, inComponent: 0, animated: false)
        }
        self.highPrioritySwitch.setOn(task?.highPriority ?? false, animated: false)
        self.descriptionLabel.text = task?.taskDescription
        
        if let cost = task?.cost {
            self.costLabel.text = String(format: "%.2f", cost)
        }
    }
    
    @objc func clickDone(item:UIBarButtonItem) {
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        
        var recordData = [String:Any]()
        recordData["title"] = self.titleTextField.text
        recordData["dueDay"] = self.datePickerView.date
        recordData["repeat"] = self.repeatTitles[self.repeatPickerView.selectedRow(inComponent: 0)].rawValue
        recordData["finish"] = false
        recordData["taskType"] = TaskType.Expense.rawValue
        recordData["highPriority"] = highPrioritySwitch.isOn
        recordData["taskDescription"] = self.descriptionLabel.text
        recordData["cost"] = Double(self.costLabel.text ?? "") ?? 0.0
        //Update Value
        if (self.task != nil) {
            
            CloudKitManager.updateRecord((task?.identifier)!, recordData: recordData, completion: { (record, error) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.navigationController?.popToRootViewController(animated: true)
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                })
            })
            
        }else{
            CloudKitManager.createRecord(recordData) { (record, error) in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    self.navigationController?.popToRootViewController(animated: true)
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                })
                
            }
        }
        
    }
    
}

extension ExpenseEditViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 6:
            CloudKitManager.removeRecord((task?.identifier!)!, completion: { (_, _) in
                self.navigationController?.popToRootViewController(animated: true)
            })
            break
        default:
            break
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (self.task == nil && indexPath.row == 6){
            return CGFloat.leastNormalMagnitude
        }else if (self.task != nil && indexPath.row == 6 ){
            return 50
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
}


extension ExpenseEditViewController : UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return repeatTitles[row].description
    }
}

