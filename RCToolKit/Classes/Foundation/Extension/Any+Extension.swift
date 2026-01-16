//
//  Any+Extension.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/8.
//

import Foundation

extension NSObject:ExtensionCompatible {}
extension Float:ExtensionCompatible {}
extension Double:ExtensionCompatible {}

extension CGSize:ExtensionCompatible {}
extension CGFloat:ExtensionCompatible {}

extension Int:ExtensionCompatible {}

public extension ExtensionWrapper {
    var threadId:__uint64_t {
        get {
            let thrid = UnsafeMutablePointer<__uint64_t>.allocate(capacity: 1)
            if  pthread_threadid_np(nil,thrid) == 0 {
                let threadId = thrid.pointee
                thrid.deallocate()
                return threadId
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
    func wrapperValue()->Base {
        return base
    }
    
}
public extension ExtensionWrapper where Base == Float {
    var isZero:Bool {
        let dpsinon :Float = 1.00e-07
        return (base >= -dpsinon) && (base <= dpsinon)
    }
    var half:Float {
        return base / 2.0
    }
    
    var double:Float {
        return base * 2.0
    }
    var min:Float {
        return Float(CGFLOAT_MIN)
    }
    var max:Float {
        return Float(CGFLOAT_MAX)
    }
}
public extension ExtensionWrapper where Base == CGFloat {
    func randiansToDegress(_ radians:CGFloat) ->CGFloat {
        return radians * (.pi / 360.0)
    }
    
    func toSize() -> CGSize {
        return CGSizeMake(base,base)
    }
}

public extension ExtensionWrapper where Base == CGFloat.Type {
    var min:CGFloat {
        return CGFloat(CGFLOAT_MIN)
    }
    var max:CGFloat {
        return CGFloat(CGFLOAT_MAX)
    }
}
public extension ExtensionWrapper where Base == CGSize {
    func swip() ->CGSize {
        return CGSize(width: base.height, height: base.width)
    }
    func scale(_ scale:CGFloat) -> CGSize {
        return CGSize(width: base.width * scale, height: base.height * scale)
    }
}

public extension ExtensionWrapper where Base:Encodable {
    func toJsonString() -> String? {
        guard let data = try? JSONEncoder().encode(base) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

public extension ExtensionWrapper where  Base == Int {
    func toSize() -> CGSize {
        return CGSizeMake(CGFloat(base),CGFloat(base))
    }
    func toString() -> String {
        return "\(base)"
    }
}
