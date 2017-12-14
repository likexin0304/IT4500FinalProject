//
//  ViewController.swift
//  RoommatesToDo
//
//  Created by Kexin Li on 2017/12/6.
//  Copyright © 2017年 Anson. All rights reserved.
//

import UIKit
import CloudKit

class DashBoardTableViewCell :UITableViewCell {
    @IBOutlet weak var whiteBackgroundView: UIView!
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var repeatLabel: UILabel!
    
    var task:Task? {
        didSet {
            self.titleLabel.text = task?.title
            switch task!.type {
            case .Chore?:
                self.leftImageView.image = UIImage(named: "bulb")
                break
            case .Expense?:
                self.leftImageView.image = UIImage(named: "budget")
                break
            case .none:
                break
            }
            
            switch task?.`repeat` {
            case .NoRepeat?:
                self.repeatLabel.text = ""
                break
            case .Weekly?:
                self.repeatLabel.text = "Repeat Weekly"
                break
            case .Monthly?:
                self.repeatLabel.text = "Repeat Monthly"
                break
            default:
                break
            }
            
            guard let highPriority = task?.highPriority else {return}
            
            self.titleLabel.textColor = highPriority ? UIColor.red : UIColor.black
        }
    }
    
    override func awakeFromNib() {
        whiteBackgroundView.layer.cornerRadius = 5
        whiteBackgroundView.layer.shadowColor = UIColor.gray.cgColor
        whiteBackgroundView.layer.shadowRadius = 5
        whiteBackgroundView.layer.shadowOffset = CGSize(width: 5, height: 5)
        whiteBackgroundView.layer.shadowOpacity = 0.4
        whiteBackgroundView.layer.borderColor = UIColor.lightGray.cgColor
        whiteBackgroundView.layer.borderWidth = 0.5
        layer.masksToBounds = true
    }
    
}


class DashBoardViewController: UITableViewController {

    
    var sortedTasks = [[Task]]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        queryTasksList(completion: {
            self.tableView.reloadData()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.tableFooterView = UIView()
    }
    
    
    func queryTasksList (completion:(() -> Void)?) {
        CloudKitManager.fetchAllTasks { (result, error) in
            
            guard let result = result else {
                self.tableView.reloadData()
                return
            }
            
            self.sortTasksByDay(tasks: result)

            if (completion != nil){
                completion!()
            }
        }
    }
    
    
    func sortTasksByDay(tasks:[Task]){
        
        
        self.sortedTasks = [[Task]]()
        
        var todayRepeatTask = [Task]()
        let repeatTasks = tasks.filter{tasks in tasks.`repeat` != .NoRepeat}
        for task in repeatTasks {
            guard let dueday = task.dueDay, let `repeat` = task.`repeat` else {continue}
            let remainDays = dueday.remainDaysToDate(endDate: Date())
            if (remainDays % `repeat`.rawValue == 0) {
                todayRepeatTask.append(task)
            }
        }
        
//        if (todayRepeatTask.count > 0){
            self.sortedTasks.append(todayRepeatTask)

//        }
        
        var tempYear:Int = 0
        var tempMonth:Int = 0
        var tempDay:Int = 0
        
        let calendar = NSCalendar.current
        var tempArray = [Task]()
        
        var index:Int = 0
        tasks.forEach { (task) in
            let dateComponent = calendar.dateComponents([.day,.month,.year], from: task.dueDay!)
            if (dateComponent.year != tempYear || dateComponent.month != tempMonth || dateComponent.day != tempDay) {
                if (tempArray.count > 0){
                    sortedTasks.append(tempArray)
                }
                tempArray = [Task]()
                tempArray.append(task)
            }else{
                tempArray.append(task)
            }
            //MARK:If is the last element put it into a new array
            if (index == tasks.count - 1) {
                sortedTasks.append(tempArray)
            }
            
            tempYear = dateComponent.year!
            tempMonth = dateComponent.month!
            tempDay = dateComponent.day!
            index += 1
        }
        
    }
    
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        queryTasksList{
            self.tableView.reloadData()
            sender.endRefreshing()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DashBoardViewController  {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sortedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedTasks[safe:section]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoardTableViewCell") as! DashBoardTableViewCell
        let task = self.sortedTasks[safe:indexPath.section]?[safe:indexPath.row]
        cell.task = task
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0){
            return "Today's Repeat Task"
        }
        let date = sortedTasks[safe:section]?[safe:0]?.dueDay
        return date?.toString(withFormat: "MM-dd-yyyy")
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let count = self.tableView(tableView, numberOfRowsInSection: section)
        if (count > 0){
            return 40
        }else{
            return CGFloat.leastNormalMagnitude
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = self.sortedTasks[safe:indexPath.section]?[safe:indexPath.row]
            switch task?.type {
            case .Chore?:
                self.tabBarController?.selectedIndex = 1
            case .Expense?:
                self.tabBarController?.selectedIndex = 2
            default:
                break
            }

        }
}

