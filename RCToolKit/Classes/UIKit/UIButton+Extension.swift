//
//  UIButton+Extension.swift
//  RCToolKit
//
//  Created by yoyo on 2024/9/27.
//

import Foundation
import UIKit
extension UIButton: ExtensionCompatibleValue {}


private var ExtendEdgeInsetsKey: Void?

public extension UIButton {

    /// 设置此属性即可扩大响应范围, 分别对应上左下右
    /// 优势：与Auto-Layout无缝配合
    /// 劣势：View Debugger 查看不到增加的响应区域有多大，
    var extendEdgeInsets: UIEdgeInsets {
        get {
            return objc_getAssociatedObject(self, &ExtendEdgeInsetsKey) as? UIEdgeInsets ?? UIEdgeInsets.zero
        }
        set {
            objc_setAssociatedObject(self, &ExtendEdgeInsetsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if UIEdgeInsetsEqualToEdgeInsets(extendEdgeInsets, .zero) || !self.isEnabled || self.isHidden || self.alpha < 0.01 {
            return super.point(inside: point, with: event)
        }
        let newRect = extendRect(bounds, extendEdgeInsets)
        return newRect.contains(point)
    }

    private func extendRect(_ rect: CGRect, _ edgeInsets: UIEdgeInsets) -> CGRect {
        let x = rect.minX - edgeInsets.left
        let y = rect.minY - edgeInsets.top
        let w = rect.width + edgeInsets.left + edgeInsets.right
        let h = rect.height + edgeInsets.top + edgeInsets.bottom
        return CGRect(x: x, y: y, width: w, height: h)
    }
}

public extension ExtensionWrapper where Base: UIButton {
    @discardableResult
    func setTitle(title:String) ->ExtensionWrapper{
        base.setTitle(title, for: .normal)
        base.setTitle(title, for: .highlighted)
        return self
    }
    
    @discardableResult
    func setTitleFont(font:UIFont) ->ExtensionWrapper{
        base.titleLabel?.font = font
        return self
    }

    @discardableResult
    func setTitleColor(color:UIColor) ->ExtensionWrapper {
        base.setTitleColor(color, for: .normal)
        base.setTitleColor(color, for: .highlighted)
        return self
    }
    @discardableResult
    func setTitleShadowColor(_ color: UIColor?) ->ExtensionWrapper {
        base.setTitleShadowColor(color, for: .normal)
        base.setTitleShadowColor(color, for: .highlighted)
        return self
    }
    @discardableResult
    func setImage(_ image: UIImage?)->ExtensionWrapper  {
        base.setImage(image, for: .normal)
        base.setImage(image, for: .highlighted)
        return self
    }
    @discardableResult
    func setBackgroundImage(_ image: UIImage?) ->ExtensionWrapper  {
        base.setBackgroundImage(image, for: .normal)
        base.setBackgroundImage(image, for: .highlighted)
        return self
    }

//    @available(iOS 13.0, *)
//    func setPreferredSymbolConfiguration(_ configuration: UIImage.SymbolConfiguration?, forImageIn state: UIControl.State) {
//
//    }

//    @available(iOS 6.0, *)
//    func setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State) // default is nil. title is assumed to be single
}
public extension ExtensionWrapper where Base == UIButton.Type {
    var empty: UIButton {
        get {
            return UIButton(type: .custom)
        }
    }
}
