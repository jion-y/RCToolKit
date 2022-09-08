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
