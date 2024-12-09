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
        self.backgroundColor = .rc.rgba(r: 0, g: 0, b: 0, a: 0.7)
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RCPopupView.hidden))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tap)
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
    @objc public func hidden() {
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
