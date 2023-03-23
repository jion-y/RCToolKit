//
//  UIDevice+Extension.swift
//  RCToolKit
//
//  Created by yoyo on 2023/3/23.
//

import Foundation

public extension ExtensionWrapper where Base == UIDevice.Type {
    var screenWidth:CGFloat {
        get {
            return UIScreen.main.bounds.width
        }
    }
    
    var screenHeight:CGFloat {
        get {
            return UIScreen.main.bounds.height
        }
    }
}
