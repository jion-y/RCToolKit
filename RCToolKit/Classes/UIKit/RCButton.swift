//
//  RCButton.swift
//  RCToolKit
//
//  Created by yoyo on 2024/10/14.
//

import Foundation
open class RCButton:UIButton {
    //将 layer 的类型设置成 CAGradientLayer,用来满足一些复杂的背景颜色设置
    open override class var layerClass: AnyClass {
        get {
            return CAGradientLayer.self
        }
    }
}
