//
//  UIView+Gradient.swift
//  RCToolKit
//
//  Created by yoyo on 2024/10/14.
//

import Foundation

public extension ExtensionWrapper where Base: UIView{
     var colors: [Any]? {
        set {
            guard let gradientLayer = self.base.layer as? CAGradientLayer else {
                return
            }
            gradientLayer.colors = newValue
        }
        get {
            guard let gradientLayer = self.base.layer as? CAGradientLayer else {
                return nil
            }
            return gradientLayer.colors
        }
    }
    
     var locations: [NSNumber]? {
        set {
            guard let gradientLayer = self.base.layer as? CAGradientLayer else {
                return
            }
            gradientLayer.locations = newValue
        }
        get {
            guard let gradientLayer = self.base.layer as? CAGradientLayer else {
                return nil
            }
            return gradientLayer.locations
        }
    }
    
     var startPoint: CGPoint {
        set {
            guard let gradientLayer = self.base.layer as? CAGradientLayer else {
                return
            }
            gradientLayer.startPoint = newValue
        }
        get {
            guard let gradientLayer = self.base.layer as? CAGradientLayer else {
                return .zero
            }
            return gradientLayer.startPoint
        }
    }

     var endPoint: CGPoint {
        set {
            guard let gradientLayer = self.base.layer as? CAGradientLayer else {
                return
            }
            gradientLayer.endPoint = newValue
        }
        get {
            guard let gradientLayer = self.base.layer as? CAGradientLayer else {
                return .zero
            }
            return gradientLayer.endPoint
        }
    }
    
    @discardableResult
    mutating func setColor(colors:Array<CGColor>) -> ExtensionWrapper {
        self.colors = colors
        return self
    }
    @discardableResult
    mutating func setLocations(locations:Array<NSNumber>) -> ExtensionWrapper {
        self.locations = locations
        return self
    }
    @discardableResult
    mutating func setStartPoint(startPoint:CGPoint) -> ExtensionWrapper {
        self.startPoint = startPoint
        return self
    }
    @discardableResult
    mutating func setEndPoint(endPoint:CGPoint) -> ExtensionWrapper {
        self.endPoint = endPoint
        return self
    }
}
