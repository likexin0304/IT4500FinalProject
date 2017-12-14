//
//  ChoreDetailViewController.swift
//  RoommatesToDo
//
//  Created by Kexin Li on 2017/12/10.
//  Copyright © 2017年 Anson. All rights reserved.
//

import UIKit

class ChoreDetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var highPriorityLabel: UILabel!
    
    var task:Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        title = "Chore Detail"
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(clickEdit(item:)))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        self.titleLabel.text = task?.title
        self.dateLabel.text = "Date:" + (task?.dueDay?.toString(withFormat: "MM-dd-yyyy"))!
        self.highPriorityLabel.text = "High Priority:" + ((task?.highPriority)! ? "YES" : "NO")
        self.repeatLabel.text = "Repeat: " + (task?.`repeat`?.description)!
    }

    
    @objc func clickEdit(item:UIBarButtonItem) {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChoreEditViewController") as! ChoreEditViewController
        viewController.task = task
        self.navigationController?.pushViewController(viewController, animated: true)
       
    }

}
