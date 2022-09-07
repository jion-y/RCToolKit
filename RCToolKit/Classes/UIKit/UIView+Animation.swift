//
//  UIView+Animation.swift
//  LYKit
//
//  Created by liuming on 2021/3/19.
//

import Foundation
import UIKit

extension ExtensionWrapper where Base: UIView {
    public enum ShakeDirection: Int {
        case horizontal
        case vertical
    }
    func shake(direction: ShakeDirection = .horizontal, times: Int = 5,
               interval: TimeInterval = 0.1, delta: CGFloat = 2,
               completion: (() -> Void)? = nil)
    {
        UIView.animate(withDuration: interval, animations: { () -> Void in
            switch direction {
            case .horizontal:
                self.base.layer.setAffineTransform(CGAffineTransform(translationX: delta, y: 0))
            case .vertical:
                self.base.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: delta))
            }
        }) { (_) -> Void in
            if times == 0 {
                // last shaking finish, reset location, callback
                UIView.animate(withDuration: interval, animations: { () -> Void in
                    self.base.layer.setAffineTransform(CGAffineTransform.identity)
                }, completion: { (_) -> Void in
                    completion?()
                })
            }
            else {
                // not last shaking, continue
                self.shake(direction: direction, times: times - 1, interval: interval,
                           delta: delta * -1, completion: completion)
            }
        }
    }
}
