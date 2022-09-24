//
//  LYWrapper.swift
//  LYCaffe
//
//  Created by liuming on 2021/10/29.
//

import Foundation
public struct ExtensionWrapper<Base>{
    public let base:Base
    init(_ base:Base) {
        self.base = base;
    }
}
public protocol ExtensionCompatible { }
public protocol ClasseExtensionCompatible:AnyObject {}

public protocol ExtensionCompatibleValue {}

extension ExtensionCompatible {
    public var rc: ExtensionWrapper<Self> {
        get { return ExtensionWrapper(self) }
        set { }
    }
    public static var rc:ExtensionWrapper<Self.Type> {
        get { return ExtensionWrapper(self) }
        set { }
    }
}

//extension ExtensionCompatibleValue {
//    public var rc: ExtensionWrapper<Self> {
//        get { return ExtensionWrapper(self) }
//        set { }
//    }
//}

