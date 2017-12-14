//
//  Date+Extension.swift
//  RoommatesToDo
//
//  Created by Kexin Li on 2017/12/7.
//  Copyright © 2017年 Anson. All rights reserved.
//

import Foundation


extension Date {
    
    func toString(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let myString = formatter.string(from: self)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = format
        
        return formatter.string(from: yourDate!)
    }
    
    func remainDaysToDate(endDate: Date) -> Int {
        
        let calendar = NSCalendar.current
        
        let components = calendar.dateComponents([.day], from: self, to: endDate)
        
        return components.day!
    }
}
