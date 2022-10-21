//
//  UIColor+Extension.swift
//  RCToolKit
//
//  Created by yoyo on 2022/10/21.
//

import Foundation
extension UIImage: ExtensionCompatibleValue {}
public extension ExtensionWrapper where Base == UIColor.Type {
    
    func rbga(r:UInt,g:UInt,b:UInt,a:UInt)->UIColor {
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a))
    }
    
}
