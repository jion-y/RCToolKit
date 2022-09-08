//
//  Any+Extension.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/8.
//

import Foundation

extension NSObject:ExtensionCompatible {}

public extension ExtensionWrapper {
    var threadId:__uint64_t {
        get {
            let thrid = UnsafeMutablePointer<__uint64_t>.allocate(capacity: 1)
            if  pthread_threadid_np(nil,thrid) == 0 {
                return thrid.pointee
            }
            return 0;
        }
    }
    var threadName:String {
        get {
            var chars:[Int8] = Array(repeating: 0, count:128)
            let error = pthread_getname_np(pthread_self(), &chars, chars.count)
            if error != 0 {
                return String.rc.empty
            }
            let characters = chars.filter { $0 != 0 }.map { UInt8($0) }.map(UnicodeScalar.init).map(Character.init)
            let name = String(characters)
            return name
        }
    }
    var queueLabel:String  {
        get {
            return String(validatingUTF8: __dispatch_queue_get_label(nil)) ?? String.rc.empty
            
        }
    }
}
