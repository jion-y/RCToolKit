//
//  UIView+Animation.swift
//  LYKit
//
//  Created by liuming on 2021/3/19.
//

import Foundation
import UIKit

extension UIView:ExtensionCompatible{}

public enum UIViewAnimationFlipDirection {
    case Top
    case Left
    case Right
    case Bottom
    
    func subDescript() -> String {
        switch self {
        case .Top:
            return "fromTop"
        case .Left:
            return "fromLeft"
        case .Bottom:
            return "fromBottom"
        case .Right:
            return "fromRight"
        }
    }
}

public enum UIViewAnimationRotationDirection:Int {
    case Right = 0
    case Left
}

public extension ExtensionWrapper where Base : UIView {
    enum ShakeDirection: Int {
        case horizontal
        case vertical
    }
    var isAnimating:Bool {
        guard let keys = base.layer.animationKeys() else {
            return false
        }
        return keys.count > 0 ? true : false
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
    
    func animateThing(offsetX: CGFloat, offsetY: CGFloat, alpha: CGFloat, time: TimeInterval, delay: TimeInterval) {
          let targetY = base.center.y
          let targetX = base.center.x
          let targetAlpha = base.alpha
          
        base.center.y = base.center.y - offsetY
        base.center.x = base.center.x - offsetX
          base.alpha = base.alpha - alpha
        UIView.animate(withDuration: time, delay: delay, options: .curveEaseOut) {
            base.center.y = targetY
            base.center.x = targetX
            base.alpha = targetAlpha
        } completion: { _ in  }
      }
    func shakeHorizontally() {
        let keyAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        keyAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)]
        keyAnimation.duration = 0.5
        keyAnimation.values = [-12,12,-8,8,-4,4,0]
        base.layer.add(keyAnimation, forKey: "shake")
    }
    
    func shakeVertically() {
        let keyAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        keyAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)]
        keyAnimation.duration = 0.5
        keyAnimation.values = [-12,12,-8,8,-4,4,0]
        base.layer.add(keyAnimation, forKey: "shake")
    }
    func applyMtionEffects() {
        let horizontalEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontalEffect.minimumRelativeValue =  -10.0
        horizontalEffect.maximumRelativeValue = 10.0
        
        let verticalEffect =  UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        verticalEffect.minimumRelativeValue =  -10.0
        verticalEffect.maximumRelativeValue = 10.0
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalEffect,verticalEffect]
        base.addMotionEffect(group)
    }
    
    func pulse(scale:CGFloat,duration:TimeInterval,repeated:Bool) {
        let baseAnimation = CABasicAnimation(keyPath: "transform.scale")
        baseAnimation.toValue = scale
        baseAnimation.duration = duration
        baseAnimation.repeatCount = Float(repeated ? Int.max : 0)
        baseAnimation.autoreverses = true
        base.layer.add(baseAnimation, forKey: "pulse")
    }
    func filpWithDuration(duration:TimeInterval,direction:UIViewAnimationFlipDirection,repeatCount:Float,autoreverse:Bool = true) {
        
        let subtype = direction.subDescript()
        let transition = CATransition()
        
        transition.startProgress = 0.0
        transition.endProgress = 1.0
        transition.type = "flip"
        transition.subtype = subtype
        transition.duration = duration
        transition.repeatCount = repeatCount
        transition.autoreverses = autoreverse
        base.layer.add(transition, forKey: "spin")
    }
    func rotate(angle:CGFloat,duration:TimeInterval,direction:UIViewAnimationRotationDirection,repeatCount:Float,autoreverse:Bool) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = direction == .Right ? angle : -angle
        rotationAnimation.duration = duration;
        rotationAnimation.autoreverses = autoreverse;
        rotationAnimation.repeatCount = repeatCount;
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        base.layer.add(rotationAnimation, forKey: "transform.rotation.z")
        
    }
    
    func stopAnimation(){
        CATransaction.begin()
        base.layer.removeAllAnimations()
        CATransaction.commit()
        CATransaction.flush()
    }
    
}
