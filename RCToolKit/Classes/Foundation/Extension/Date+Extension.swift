//
//  Date+Extension.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/8.
//

import Foundation
extension Date:ExtensionCompatible {}


public extension ExtensionWrapper where Base == Date.Type {
    var now:Date {
        get {
            if #available(iOS 15, *) {
                return Date.now
            } else {
                // Fallback on earlier versions
                return Date()
            }
        }
    }
    
  
    
}

public extension ExtensionWrapper where Base == Date {
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self.base)
    }
    
    func dateAndTimetoString(format: String = "yyyy-MM-dd HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self.base)
    }
    
    func timeIn24HourFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self.base)
    }
    
    func startOfMonth() -> Date {
        var components = Calendar.current.dateComponents([.year,.month], from: self.base)
        components.day = 1
        let firstDateOfMonth: Date = Calendar.current.date(from: components)!
        return firstDateOfMonth
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func startOfDaySecond()->Int64 {
        let dateStr = self.toString()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "yyyy-MM-dd"
        guard let data =  formatter.date(from: dateStr) else {
            return 0
        }
        return abs(Int64(data.timeIntervalSinceNow))
    }
    
    func endOfDaySecond()->Int64 {
        let dateStr = self.toString()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "yyyy-MM-dd"
        guard let data =  formatter.date(from: dateStr) else {
            return 0
        }
        let dayTotalSecond:Int64 = 24 * 60 * 60
        return dayTotalSecond - abs(Int64(data.timeIntervalSinceNow))
    }
    func endOfDaySecondString()->String {
        let endTime = endOfDaySecond()
        let hour = endTime / ( 60 * 60)
        let minu = (endTime / 60)  % 60
        let second = endTime % 60
        return String(format: "%02d:%02d:%02d", hour,minu,second)
    }

    func nextDate() -> Date {
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: self.base)
        return nextDate ?? Date()
    }
    
    func previousDate() -> Date {
        let previousDate = Calendar.current.date(byAdding: .day, value: -1, to: self.base)
        return previousDate ?? Date()
    }
    
    func addMonths(numberOfMonths: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .month, value: numberOfMonths, to: self.base)
        return endDate ?? Date()
    }
    
    func removeMonths(numberOfMonths: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .month, value: -numberOfMonths, to: self.base)
        return endDate ?? Date()
    }
    
    func removeYears(numberOfYears: Int) -> Date {
        let endDate = Calendar.current.date(byAdding: .year, value: -numberOfYears, to: self.base)
        return endDate ?? Date()
    }
    
    func getHumanReadableDayString() -> String {
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]
        
        let calendar = Calendar.current.component(.weekday, from: self.base)
        return weekdays[calendar - 1]
    }
}

