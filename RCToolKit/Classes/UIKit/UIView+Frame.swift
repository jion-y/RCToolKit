//
//  UIView+Frame.swift
//  LYCaffe
//
//  Created by liuming on 2021/10/29.
//

import Foundation
import UIKit

extension ExtensionWrapper where Base: UIView {
    public var x: CGFloat {
        set {
            var frame = self.base.frame
            frame.origin.x = newValue
            self.base.frame = frame
        }
        get {
            return self.base.frame.origin.x
        }
    }
    
    public  var y: CGFloat {
        set {
            var frame = self.base.frame
            frame.origin.y = newValue
            self.base.frame = frame
        }
        get {
            return self.base.frame.origin.y
        }
    }
    
    public   var centerX: CGFloat {
        set {
            var center = self.base.center
            center.x = newValue
            self.base.center = center
        }
        get {
            return self.base.center.x
        }
    }
    
    public   var centerY: CGFloat {
        set {
            var center = self.base.center
            center.y = newValue
            self.base.center = center
        }
        get {
            return self.base.center.y
        }
    }
    
    public var width: CGFloat {
        set {
            var frame = self.base.frame
            frame.size.width = newValue
            self.base.frame = frame
        }
        get {
            return self.base.frame.size.width
        }
    }
    
    public var height: CGFloat {
        set {
            var frame = self.base.frame
            frame.size.height = newValue
            self.base.frame = frame
        }
        get {
            return self.base.frame.size.height
        }
    }
    
    public  var size: CGSize {
        set {
            var frame = self.base.frame
            frame.size = newValue
            self.base.frame = frame
        }
        get {
            return self.base.frame.size
        }
    }
    
    public  var origin: CGPoint {
        set {
            var frame = self.base.frame
            frame.origin = newValue
            self.base.frame = frame
        }
        get {
            return self.base.frame.origin
        }
    }
    
    public var bottomY: CGFloat {
        set {
            var frame = self.base.frame
            frame.origin.y = newValue - frame.size.height
            self.base.frame = frame
        }
        get {
            return self.height + self.y
        }
    }
    
    public var rightX: CGFloat {
        set {
            var frame = self.base.frame
            frame.origin.x = newValue - frame.size.width
            self.base.frame = frame
        }
        get {
            return self.width + self.x
        }
    }
}

extension ExtensionWrapper where Base == UIView.Type  {
    public var empty :UIView { return  UIView(frame: .zero) }
}

