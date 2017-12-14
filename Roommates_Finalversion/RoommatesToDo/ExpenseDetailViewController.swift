//
//  ExpenseDetailViewController.swift
//  RoommatesToDo
//
//  Created by Kexin Li on 2017/12/10.
//  Copyright © 2017年 Anson. All rights reserved.
//

import UIKit

class ExpenseDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var highPriorityLabel: UILabel!
 
    var task:Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        title = "Expense Detail"
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(clickEdit(item:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        self.titleLabel.text = task?.title
        self.descriptionLabel.text = "Description: " + (task?.taskDescription)!
        self.costLabel.text = "Cost: " + "$" + String(format: "%.2f", arguments:[(task?.cost)!])
        self.dateLabel.text = "Date: " + (task?.dueDay?.toString(withFormat: "MM-dd-yyyy"))!
        self.highPriorityLabel.text = "High Priority: " + ((task?.highPriority)! ? "YES" : "NO")
        self.repeatLabel.text = "Repeat: " + (task?.`repeat`?.description)!
    }

    @objc func clickEdit(item:UIBarButtonItem) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ExpenseEditViewController") as! ExpenseEditViewController
        viewController.task = task
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }



}
