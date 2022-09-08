//
//  RCLog.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/7.
//

import Foundation

public enum LogLevel {
    case off
    case debug
    case info
    case warning
    case error
    case all
    var des:String {
        switch self {
        case .off :
            return "off"
        case .debug :
            return "Debug"
        case .info :
            return "Info"
        case .warning :
            return "Warnning"
        case .error:
            return "Error"
        case .all:
            return "All"
        }
    }
}
public protocol logFomatreralbel {
    func formatter(_ msg:RCLogMessage) ->String
}

public protocol LogOutputAble:NSObject {
    var formatter:logFomatreralbel? {get set}
    func logMessage(msg:RCLogMessage);
}

public class RCLog {
    public static var `default` = RCLog()
    private let logQueue = DispatchQueue(label: logQueueName,qos: .default)
    public let loggers:ThreadSafeArray<RCLogNode> = ThreadSafeArray()
    private static let logQueueName:String = "com.rc.logger"
}
extension RCLog {
    
    public static func addLogger(logger:LogOutputAble) {
        RCLog.default.addLogger(logger: logger,level: .all)
    }
    public static func removeLogger(logger:LogOutputAble) {
        RCLog.default.removeLogger(logger: logger)
    }
    
    public static func logInfo(
        message:String,
        tag:String = "",
        file:String = #file,
        function:String = #function,
        line:Int = #line) {
            log(asynchronous: true, level: .info, message: message,tag: tag,file: file,function: function,line: line)
        }
    public static func logD(
        message:String,
        tag:String = "",
        file:String = #file,
        function:String = #function,
        line:Int = #line) {
            log(asynchronous: true, level: .debug, message: message,tag: tag,file: file,function: function,line: line)
        }
    public static func logW(
        message:String,
        tag:String = "",
        file:String = #file,
        function:String = #function,
        line:Int = #line) {
            log(asynchronous: true, level: .warning, message: message,tag: tag,file: file,function: function,line: line)
        }
    public static func logE(
        message:String,
        tag:String = "",
        file:String = #file,
        function:String = #function,
        line:Int = #line) {
            log(asynchronous: true, level: .error, message: message,tag: tag,file: file,function: function,line: line)
        }
    public static func log(asynchronous:Bool,
                           level:LogLevel,
                           message:String,
                           tag:String = "",
                           file:String = #file,
                           function:String = #function,
                           line:Int = #line) {
        RCLog.default.log(asynchronous: asynchronous, level: level, message: message,tag: tag,file: file,function: function,line: line)
        
    }
}

extension RCLog {
    
    public func log(asynchronous:Bool,
                    level:LogLevel,
                    message:String,
                    tag:String = "",
                    file:String = #file,
                    function:String = #function,
                    line:Int = #line) {
        
        
        let msg:RCLogMessage = RCLogMessage(type: level,
                                            message: message,
                                            funcName: function,
                                            line: "\(line)",
                                            threadId: "\(NSObject.rc.threadId)",
                                            threadName: NSObject.rc.threadName,
                                            queueLabel: NSObject.rc.queueLabel,
                                            file: file,
                                            tag: tag);
        self.loggers.forEach { n in
            n.logger.logMessage(msg: msg)
        }
    }
    public  func addLogger(logger:LogOutputAble,level:LogLevel) {
        loggers.forEach { node in
            if logger == node.logger && node.level == level {
                return ;
            }
        }
        let node = RCLogNode(level: level, logger: logger, queue: self.logQueue)
        self.loggers.append(node);
        
    }
    public  func removeLogger(logger:LogOutputAble) {
        var node:RCLogNode? = nil
        var index:Int  = -1;
        loggers.forEach { n in
            index += 1
            if logger == n.logger {
                node = n
                return
            }
        }
        guard let _ = node else {
            return
        }
        self.loggers.remove(at: index)
        
    }
}

public class RCLogNode {
    public var logger:LogOutputAble
    public var level:LogLevel = .off
    public var loggerQueue:DispatchQueue = .main
    init(level:LogLevel,logger:LogOutputAble,queue:DispatchQueue) {
        self.logger = logger
        self.level = level
        self.loggerQueue = queue
    }
}
extension RCLogNode:Equatable {
    public static func == (lhs: RCLogNode, rhs: RCLogNode) -> Bool {
        return (lhs.logger == rhs.logger && lhs.level == rhs.level)
    }
}
