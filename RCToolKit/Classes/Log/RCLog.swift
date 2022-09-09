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
    var emoDes: String {
        switch self {
        case .off:
            return "✖️"
        case .debug:
            return "🔨"
        case .info:
            return "📌"
        case .warning:
            return "🟨"
        case .error:
            return "😡"
        case .all:
            return "😋"
        }
    }
    var des: String {
        switch self {
        case .off:
            return "off"
        case .debug:
            return "Debug"
        case .info:
            return "Info"
        case .warning:
            return "Warnning"
        case .error:
            return "Error"
        case .all:
            return "All"
        }
    }
}

public protocol logFomatreralbel {
    func formatter(_ msg: RCLogMessage,emo:Bool) -> String
}

public protocol LogOutputable: NSObject {
    var formatter: logFomatreralbel? { get set }
    func logMessage(msg: RCLogMessage)
    func flush()
}



public class RCLog {
    public static var `default` = RCLog()
    private let logQueue = DispatchQueue(label: logQueueName, qos: .default)
    public let loggers: ThreadSafeArray<RCLogNode> = ThreadSafeArray()
    private static let logQueueName: String = "com.rc.logger"
    private var timeLogMap: ThreadSafeDictionary<String,UInt64> = ThreadSafeDictionary()
    public var logLevel:LogLevel = .all
}

public extension RCLog {
    func LogT(tag: String,
              file: String = #file,
              function: String = #function,
              line: Int = #line)
    {
        let millInterval = UInt64(Date.rc.now.timeIntervalSince1970 * 1000.0)
        guard let preTime = self.timeLogMap[tag] else {
            self.timeLogMap[tag] = millInterval
            return
        }
        let detalTime = millInterval - preTime
        self.log(asynchronous: true, level: .info, message: " \(detalTime) ms", tag: tag, file: file, function: function, line: line)
        self.timeLogMap[tag] = millInterval
    }

    func removeLogT(tag: String, file: String = #file,
                    function: String = #function,
                    line: Int = #line)
    {
        self.timeLogMap.removeValue(forKey: tag)
    }

    func log(asynchronous: Bool,
             level: LogLevel,
             message: String,
             tag: String = "",
             file: String = #file,
             function: String = #function,
             line: Int = #line)
    {
        if !invalidLogLevel(level: level) { return }
        let msg = RCLogMessage(type: level,
                               message: message,
                               funcName: function,
                               line: "\(line)",
                               threadId: "\(NSObject.rc.threadId)",
                               threadName: NSObject.rc.threadName,
                               queueLabel: NSObject.rc.queueLabel,
                               file: file,
                               tag: tag)
        self.loggers.forEach { n in
            n.logger.logMessage(msg: msg)
        }
    }

    func addLogger(logger: LogOutputable, level: LogLevel) {
        self.loggers.forEach { node in
            if logger == node.logger, node.level == level {
                return
            }
        }
        let node = RCLogNode(level: level, logger: logger, queue: self.logQueue)
        self.loggers.append(node)
    }

    func removeLogger(logger: LogOutputable) {
        var node: RCLogNode?
        var index: Int = -1
        self.loggers.forEach { n in
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
    func invalidLogLevel(level:LogLevel) -> Bool {
      switch self.logLevel {
        case .off:
            return false
      case .debug :
          return level != .off
      case .info:
          return (level == .info || level == .warning  || level == .error)
      case .warning:
          return (level == .warning || level == .error)
      case .error:
          return level == .error
        default:
          return (logLevel != .off)
        }
    }
}

extension RCLog:ExtensionCompatible {}

public extension ExtensionWrapper where Base == RCLog.Type  {
    func setLogLevel(level:LogLevel) {
        RCLog.default.logLevel = level
    }
    func addLogger(logger: LogOutputable) {
        RCLog.default.addLogger(logger: logger, level: .all)
    }

     func removeLogger(logger: LogOutputable) {
        RCLog.default.removeLogger(logger: logger)
    }

    func logInfo(message: String,
                        tag: String = "",
                        file: String = #file,
                        function: String = #function,
                        line: Int = #line)
    {
        log(asynchronous: true, level: .info, message: message, tag: tag, file: file, function: function, line: line)
    }

    func logD(message: String,
                     tag: String = "",
                     file: String = #file,
                     function: String = #function,
                     line: Int = #line)
    {
       log(asynchronous: true, level: .debug, message: message, tag: tag, file: file, function: function, line: line)
    }

     func logW(message: String,
                     tag: String = "",
                     file: String = #file,
                     function: String = #function,
                     line: Int = #line)
    {
        log(asynchronous: true, level: .warning, message: message, tag: tag, file: file, function: function, line: line)
    }

     func logE(message: String,
                     tag: String = "",
                     file: String = #file,
                     function: String = #function,
                     line: Int = #line)
    {
       log(asynchronous: true, level: .error, message: message, tag: tag, file: file, function: function, line: line)
    }

    func log(asynchronous: Bool,
                    level: LogLevel,
                    message: String,
                    tag: String = "",
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line)
    {
        RCLog.default.log(asynchronous: asynchronous, level: level, message: message, tag: tag, file: file, function: function, line: line)
    }

    func LogT(tag: String,
                     file: String = #file,
                     function: String = #function,
                     line: Int = #line)
    {
        RCLog.default.LogT(tag: tag, file: file, function: function, line: line)
    }

    func removeLogT(tag: String, file: String = #file,
                           function: String = #function,
                           line: Int = #line)
    {
        RCLog.default.removeLogT(tag: tag, file: file, function: function, line: line)
    }
}
public class RCLogNode {
    public var logger: LogOutputable
    public var level: LogLevel = .off
    public var loggerQueue: DispatchQueue = .main
    init(level: LogLevel, logger: LogOutputable, queue: DispatchQueue) {
        self.logger = logger
        self.level = level
        self.loggerQueue = queue
    }
}

extension RCLogNode: Equatable {
    public static func == (lhs: RCLogNode, rhs: RCLogNode) -> Bool {
        return (lhs.logger == rhs.logger && lhs.level == rhs.level)
    }
}
