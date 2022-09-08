//
//  RCFileLog.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/8.
//

import Foundation
public class RCFileLog:NSObject {
    private var fomatter_:logFomatreralbel?
}
extension RCFileLog:LogOutputable {
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
        
    }
    
    
}
