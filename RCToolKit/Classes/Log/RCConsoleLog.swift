//
//  RCConsoleLog.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/8.
//

import Foundation
//#if canImport(OSLog)
import os.log
//#endif
public class RCConsoleLog:NSObject {
    private var fomatter_:logFomatreralbel?
}
@available(iOS 13.0, *)
extension RCConsoleLog:LogOutputable {
    
    public var formatter: logFomatreralbel? {
        get {
            guard let fmatter = fomatter_ else {
                fomatter_ = RCDefaultFormatter.default
                return fomatter_!
            }
            return fmatter;
        }
        set {
            fomatter_ = newValue
        }
    }
    
    public func logMessage(msg: RCLogMessage) {
        
        let log = self.formatter?.formatter(msg,emo: true) ?? String.rc.empty
#if canImport(OSLog)
        switch msg.type {
        case .off:
            break
        case .debug:
            os_log("%@", log: .default, type: .debug, log)
        case .info:
            os_log("%@", log: .default, type: .info, log)
        case .warning:
            os_log("%@", log: .default, type: .info, log)
        case .error:
            os_log("%@", log: .default, type: .error, log)
        case .all:
            os_log("%@", log: .default, type: .info, log)
        }
#else
        print(log)
#endif
  
    }
    
    public func flush() {
        
    }
}
