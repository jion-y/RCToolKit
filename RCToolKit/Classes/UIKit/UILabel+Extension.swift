//
//  UILabel+Extension.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/24.
//

import Foundation
extension UILabel: ExtensionCompatibleValue {}
public extension ExtensionWrapper where Base == UILabel {
    
    @discardableResult
    func text(_ text:String?)->ExtensionWrapper {
        base.text = text
        return self
    }
    @discardableResult
    func font(_ font:UIFont)->ExtensionWrapper {
        base.font = font
        return self
    }
    @discardableResult
    func textColor(_ textColor:UIColor)->ExtensionWrapper {
        base.textColor = textColor
        return self
    }
    @discardableResult
    func shadowColor(_ shadowColor:UIColor?) ->ExtensionWrapper {
        base.shadowColor = shadowColor
        return self
    }
    @discardableResult
    func shadowOffset(_ offset:CGSize)->ExtensionWrapper {
        base.shadowOffset = offset
        return self
    }
    @discardableResult
    func textAlignment(_ alignment:NSTextAlignment)->ExtensionWrapper {
        base.textAlignment = alignment
        return self
    }
    func lineBreakMode(_ lineBreakMode:NSLineBreakMode)->ExtensionWrapper {
        base.lineBreakMode = lineBreakMode
        return self
    }
    @discardableResult
    func attributedText(_ attributedText:NSAttributedString)->ExtensionWrapper {
        base.attributedText = attributedText
        return self
    }
    @discardableResult
    func highlightedTextColor(_ highlightedTextColor:UIColor?) ->ExtensionWrapper {
        base.highlightedTextColor = highlightedTextColor
        return self
    }
    @discardableResult
    func isUserInteractionEnabled(_ isUserInteractionEnabled:Bool = false)->ExtensionWrapper {
        base.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }
    @discardableResult
    func enabled(_ enabled:Bool = false)->ExtensionWrapper {
        base.isEnabled = enabled
        return self
    }
    @discardableResult
    func numberOfLines(_ numberOfLines:Int)->ExtensionWrapper {
        base.numberOfLines = numberOfLines
        return self
    }
    @discardableResult
    func adjustsFontSizeToFitWidth(_ adjusts:Bool = true)->ExtensionWrapper {
        base.adjustsFontSizeToFitWidth = adjusts
        return self
    }
    @discardableResult
    func baselineAdjustment( baselineAdjustment:UIBaselineAdjustment) ->ExtensionWrapper {
        base.baselineAdjustment = baselineAdjustment
        return self
    }
    @discardableResult
    func minimumScaleFactor(_ minimumScaleFactor:CGFloat)->ExtensionWrapper {
        base.minimumScaleFactor = minimumScaleFactor
        return self
    }
    @discardableResult
    func allowsDefaultTighteningForTruncation(_ allowed:Bool = true)->ExtensionWrapper  {
        base.allowsDefaultTighteningForTruncation = allowed
        return self
    }
    @discardableResult
    @available(iOS 14.0, *)
    func lineBreakStrategy(_ lineBreakStrategy:NSParagraphStyle.LineBreakStrategy) ->ExtensionWrapper {
        base.lineBreakStrategy = lineBreakStrategy
        return self
    }
    
}

public extension ExtensionWrapper where Base == UILabel.Type {
    var empty: UILabel {
        get {
            return UILabel(frame: .zero)
        }
    }
}
//
//extension UILabel:EmptyAble {
//    public var empty: UILabel {
//        return UILabel(frame: .zero)
//    }
//    public typealias T = UILabel
//    
//}
