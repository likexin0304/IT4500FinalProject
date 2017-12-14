//
//  Model.swift
//  RoommatesToDo
//
//  Created by Kexin Li on 2017/12/7.
//  Copyright © 2017年 Anson. All rights reserved.
//

import Foundation
import CloudKit

enum Repeat:Int,CustomStringConvertible{
    
    case NoRepeat = 0
    case Weekly = 7
    case Monthly = 30
    
    var description: String{
        switch self {
        case .Weekly:
            return "Weekly"
            
        case .Monthly:
            return "Monthly"
            
        default:
            return "No Repeat"
        }
    }
}

enum TaskType: Int{
    case Chore = 0
    case Expense = 1
}

class Task {
    
    var title:String?
    var taskDescription:String?
    var cost:Float?
    var dueDay:Date?
    var highPriority:Bool?
    var type:TaskType?
    var identifier:String?
    var finish:Bool?
    var `repeat`:Repeat?
    
    init(record:CKRecord) {
        self.title = record.value(forKey: "title") as? String
        self.taskDescription = record.value(forKey: "taskDescription") as? String
        self.cost = record.value(forKey: "cost") as? Float
        self.type = TaskType(rawValue: record.value(forKey: "taskType") as? Int ?? 0)
        self.dueDay = record.value(forKey: "dueDay") as? Date
        self.highPriority = record.value(forKey: "highPriority") as? Bool
        self.finish = record.value(forKey: "finish") as? Bool
        self.`repeat` = Repeat(rawValue: record.value(forKey: "repeat") as? Int ?? 0)
        self.identifier = record.recordID.recordName
    }
}
