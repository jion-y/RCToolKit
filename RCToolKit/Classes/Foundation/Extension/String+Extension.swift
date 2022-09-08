//
//  String+Extension.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/8.
//

import Foundation
extension String:ExtensionCompatible {}


public extension ExtensionWrapper where Base == String.Type {
    var empty:String { get { return "" }  }
}

public extension ExtensionWrapper where Base == String {
    var isEmpty:Bool { get { return base.isEmpty }  }
}


