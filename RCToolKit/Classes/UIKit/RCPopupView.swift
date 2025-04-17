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
    func onCloseEvent()
}
extension RCPopupEnabel {
    func onCloseEvent(){}
}
open class RCPopupView<T>: UIView where T:RCPopupEnabel {

    public weak var animation: T?
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .rc.rgba(r: 0, g: 0, b: 0, a: 0.7)
        let btn = self.rc.addButton(rect: .zero, image: UIImage(), target: self, action: #selector(RCPopupView.touchCloseHandler), event: .touchUpInside)
        btn.snp.makeConstraints { make in
            make.top.left.bottom.right.equalTo(0)
        }
        self.animation = T.initize(superView: self) as? T
        self.animation?.layoutView()
        self.rc.setNeedsDisplay()
    }
    
    
    public func Show(view:UIView? = UIDevice.rc.keyWindow) {
        

        if let v = view {
            v.addSubview(self)
        } else {
            
            let keyWindow = UIApplication.shared.connectedScenes
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first?.windows.first
            
            guard  let window = keyWindow else {
                return
            }
            window.addSubview(self)
        }
        
        self.animation?.showLayout()
        
        UIView.animate(withDuration: 0.35) {
            self.rc.setNeedsDisplay()
        }
        
    }
     public func hidden() {
        DispatchQueue.rc.safeRunMainQueue {
            self.animation?.hiddenLayout()
            UIView.animate(withDuration: 0.35) {
                self.rc.setNeedsDisplay()
            } completion: { completion in
                self.removeFromSuperview()
            }
        }
    }
    @objc
    private func touchCloseHandler(){
        self.animation?.onCloseEvent()
        self.hidden()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
