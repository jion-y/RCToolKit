//
//  RCLogItem.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/7.
//

import Foundation

public class RCLogMessage {
    public var type: LogLevel = .off
    public var message: String = String.rc.empty
    public var file: String = String.rc.empty
    public var funcName: String = String.rc.empty
    public var line: String = String.rc.empty
    public var date: Date = Date.rc.now
    public var threadId: String = String.rc.empty
    public var threadName: String = String.rc.empty
    public var queueLabel: String = String.rc.empty
    public var tag: String = String.rc.empty

    init(type: LogLevel,
         message: String,
         funcName: String,
         line: String,
         threadId: String,
         threadName: String,
         queueLabel: String,
         file: String?,
         date: Date = Date.rc.now,
         tag: String = String.rc.empty)
    {
        self.type = type
        self.message = message
        self.funcName = funcName
        self.line = line
        self.threadId = threadId
        self.threadName = threadName
        self.queueLabel = queueLabel
        self.file = file ?? String.rc.empty
        self.date = date
        self.tag = tag
    }
}
