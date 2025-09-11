//
//  Color+Extension.swift
//  RCToolKit
//
//  Created by yoyo on 2025/6/5.
//

import Foundation
import SwiftUI

extension Color:ExtensionCompatible {}
public extension ExtensionWrapper where Base == Color.Type {
    func rgba(r: UInt, g: UInt, b: UInt, a: CGFloat) -> Color {
        return Color(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, opacity: a)
    }
    
    func hexString(_ hexString: String) ->Color {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        return Color(red: red, green: green, blue: blue, opacity: 1)
    }

    
}
