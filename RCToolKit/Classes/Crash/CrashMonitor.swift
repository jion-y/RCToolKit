//
//  CrashMonitor.swift
//  Pods-RCToolKit_Example
//
//  Created by yoyo on 2022/9/9.
//

import Foundation

public class CrashMonitor: DefaultRCPublisher {
    public static let CrashStackInfoKey = "CrashStackInfoKey"
    
    public static var `default` = CrashMonitor()

    override private  init() {
        super.init()
        RCCrashhunter .share().start { log in
            self.Publish([CrashMonitor.CrashStackInfoKey:log as Any])
        }
    }
}
