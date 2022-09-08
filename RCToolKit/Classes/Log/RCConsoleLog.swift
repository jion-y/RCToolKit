//
//  RCConsoleLog.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/8.
//

import Foundation
public class RCConsoleLog:NSObject {
    private var fomatter_:logFomatreralbel?
    
}
extension RCConsoleLog:LogOutputAble {
    
    public var formatter: logFomatreralbel? {
        get {
            guard let fmatter = fomatter_ else {
                fomatter_ = RCDefaultFormatter.default
                return self.formatter!
            }
            return fmatter;
        }
        set {
            fomatter_ = newValue
        }
    }
    
    public func logMessage(msg: RCLogMessage) {
        print(self.formatter?.formatter(msg) ?? String.rc.empty)
    }
    
    
}
