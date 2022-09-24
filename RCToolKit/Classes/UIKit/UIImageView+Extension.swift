//
//  UIImageView+Extension.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/24.
//

import Foundation
extension UIImageView: ExtensionCompatibleValue {}

public extension ExtensionWrapper where Base == UIImageView {
    
    var isAnimating:Bool {
        return base.isAnimating
    }
    @discardableResult
    func image(_ image:UIImage?) -> ExtensionWrapper {
        base.image = image
        return self
    }
    @discardableResult
    func animationImages(_ animationImages:[UIImage]?) ->ExtensionWrapper {
        base.animationImages = animationImages
        return self
    }
    @discardableResult
    func startAnimation()->ExtensionWrapper {
        base.startAnimating()
        return self
    }
    @discardableResult
    func stopAnimation()->ExtensionWrapper {
        base.stopAnimating()
        return self
    }
    @discardableResult
    func animationDuration(_ animationDuration:TimeInterval) ->ExtensionWrapper {
        base.animationDuration = animationDuration
        return self
    }
    @discardableResult
    func animationRepeatCount(_ animationRepeatCount:Int)->ExtensionWrapper {
        base.animationRepeatCount = animationRepeatCount
        return self
    }
    
}
