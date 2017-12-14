//
//  CloudKitManager.swift
//  RoommatesToDo
//
//  Created by Kexin Li on 2017/12/7.
//  Copyright © 2017年 Anson. All rights reserved.
//

import Foundation
import CloudKit

private let recordType = "Task"

final class CloudKitManager {
    
    static var privateCloudDatabase: CKDatabase {
        return CKContainer.default().privateCloudDatabase
    }
    
    static func fetchAllTasks(_ completion: @escaping (_ records: [Task]?, _ error: NSError?) -> Void) {
        let predicate = NSPredicate(format:"finish = false")
        let query = CKQuery(recordType: recordType, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "dueDay", ascending: true)]
        privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            let tasks = records?.map(Task.init)
            DispatchQueue.main.async {
                completion(tasks, error as NSError?)
            }
        }
    }
    
    static func fetchChoreTasks(isFinished:Bool,_ completion: @escaping (_ records: [Task]?, _ error: NSError?) -> Void) {
        let predicate = NSPredicate(format: "taskType = 0 && finish = %@",NSNumber(booleanLiteral: isFinished))
        let query = CKQuery(recordType: recordType, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "dueDay", ascending: true)]
        privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            let tasks = records?.map(Task.init)
            DispatchQueue.main.async {
                completion(tasks, error as NSError?)
            }
        }
    }
    
    static func fetchExpenseTasks(isFinished:Bool, _ completion: @escaping (_ records: [Task]?, _ error: NSError?) -> Void) {
        let predicate = NSPredicate(format: "taskType = 1 && finish = %@",NSNumber(booleanLiteral: isFinished))
        let query = CKQuery(recordType: recordType, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "dueDay", ascending: true)]
        privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            let tasks = records?.map(Task.init)
            DispatchQueue.main.async {
                completion(tasks, error as NSError?)
            }
        }
    }
    
    //MARK: add a new record
    static func createRecord(_ recordData: [String: Any], completion: @escaping (_ record: CKRecord?, _ error: NSError?) -> Void) {
        let record = CKRecord(recordType: recordType)
        
        for (key,value) in recordData {
            record.setValue(value, forKey: key)
        }
        
        privateCloudDatabase.save(record) { (savedRecord, error) in
            DispatchQueue.main.async {
                completion(record, error as NSError?)
            }
        }
    }
    
    //MARK: updating the record by recordId
    static func updateRecord(_ recordId: String, recordData: [String:Any], completion: @escaping (CKRecord?, Error?) -> Void) {
        let recordId = CKRecordID(recordName: recordId)
        privateCloudDatabase.fetch(withRecordID: recordId) { updatedRecord, error in
            guard let record = updatedRecord else {
                DispatchQueue.main.async {
                    completion(nil, error as NSError?)
                }
                return
            }
            for (key,value) in recordData {
                record.setValue(value, forKey: key)
            }
            self.privateCloudDatabase.save(record) { savedRecord, error in
                DispatchQueue.main.async {
                    completion(savedRecord, error)
                }
            }
        }
    }
    
    //MARK: remove the record
    static func removeRecord(_ recordId: String, completion: @escaping (String?, NSError?) -> Void) {
        let recordId = CKRecordID(recordName: recordId)
        privateCloudDatabase.delete(withRecordID: recordId, completionHandler: { deletedRecordId, error in
            DispatchQueue.main.async {
                completion (deletedRecordId?.recordName, error as NSError?)
            }
        })
    }
    
    //MARK: check that user is logged
//    static func checkLoginStatus(_ handler: @escaping (_ islogged: Bool) -> Void) {
//        CKContainer.default().accountStatus{ accountStatus, error in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//            switch accountStatus {
//            case .available:
//                handler(true)
//            default:
//                handler(false)
//            }
//        }
//    }
    
}
