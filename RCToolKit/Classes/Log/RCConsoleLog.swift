//
//  RCConsoleLog.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/8.
//

import Foundation
#if canImport(OSLog)
import OSLog
#endif
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
        
        let log = self.formatter?.formatter(msg) ?? String.rc.empty
//#if canImport(OSLog)
//        os_log("%@", log: .default, type: .info, log)
//#else
        print(log)
//#endif
  
    }
}
