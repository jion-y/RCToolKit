//
//  RCPopupView.swift
//  RCToolKit
//
//  Created by yoyo on 2024/10/9.
//

import UIKit

public protocol RCPopupEnabel:AnyObject {
    static func initize( superView:UIView)-> RCPopupEnabel
    func showLayout()
    func hiddenLayout()
    func layoutView()
}

open class RCPopupView<T>: UIView where T:RCPopupEnabel {

    public weak var animation: T?
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.animation = T.initize(superView: self) as? T
        self.animation?.layoutView()
        self.rc.setNeedsDisplay()
    }
    
    
    public func Show() {
        
        let keyWindow = UIApplication.shared.connectedScenes
                        .map({ $0 as? UIWindowScene })
                        .compactMap({ $0 })
                        .first?.windows.first
        
        guard  let window = keyWindow else {
            return
        }
        window.addSubview(self)
        self.animation?.showLayout()
        
        UIView.animate(withDuration: 0.35) {
            self.rc.setNeedsDisplay()
        }
        
    }
    public func hidden() {
        self.animation?.hiddenLayout()
        UIView.animate(withDuration: 0.35) {
            self.rc.setNeedsDisplay()
        } completion: { completion in
            self.removeFromSuperview()
        }
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
