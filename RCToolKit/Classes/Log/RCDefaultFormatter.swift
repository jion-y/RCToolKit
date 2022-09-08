//
//  RCDefaultFormatter.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/8.
//

import Foundation
public struct RCDefaultFormatter {
    public static let `default` = RCDefaultFormatter()
    private let formatter = DateFormatter()
    init() {
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
    }
}
extension RCDefaultFormatter:logFomatreralbel {
    public func formatter(_ msg: RCLogMessage) ->String {
        var logStr = String.rc.empty
        logStr += "[\(self.formatter.string(from: msg.date))] "
        logStr += "[" + msg.type.des + "]"
        if !msg.queueLabel.isEmpty {
            logStr += "[" + msg.queueLabel + "]"
        }
        if !msg.threadId.isEmpty {
            logStr += "[" + msg.threadId + "]"
        }
        let url = URL(fileURLWithPath: msg.file)
        let fileName = url.lastPathComponent
        logStr += "[" + fileName + "]" + "[LINE: " + msg.line + "] "
        if !msg.tag.isEmpty {
            logStr += "[TAG: " + msg.tag + "] "
        }
        logStr +=  msg.message
        return logStr
    }
    
}
