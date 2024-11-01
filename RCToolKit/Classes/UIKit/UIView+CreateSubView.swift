//
//  UIView+AddSubview.swift
//  LYCaffe
//
//  Created by liuming on 2021/10/29.
//

import Foundation
import UIKit
import SnapKit
import AuthenticationServices
public extension ExtensionWrapper where Base: UIView {
    /// 往当前视图添加一个子视图
    /// - Parameters:
    ///   - rect: 子视图大小
    ///   - bgColor: 子视图背景色
    /// - Returns: 子视图
    func addView(rect: CGRect = .zero, bgColor: UIColor = .white) -> UIView {
        let view = UIView(frame: rect)
        view.backgroundColor = bgColor
        self.base.addSubview(view)
        return view
    }
  
    /// 往当前视图添加UIImageView
    /// - Parameters:
    ///   - image: 图片对象
    ///   - rect: UIImageView
    ///   - contentMode: 图片填充模式
    /// - Returns: 图片
     func addImageView(image: UIImage?, rect: CGRect = .zero, contentMode:  UIView.ContentMode = .scaleToFill) -> UIImageView {
        let imageView = UIImageView(frame: rect)
        imageView.image = image
        imageView.contentMode = contentMode
        self.base.addSubview(imageView)
        return imageView
    }
    func addImageView(imageName:String = "",rect: CGRect = .zero, contentMode:  UIView.ContentMode = .scaleToFill)-> UIImageView {
        return addImageView(image: UIImage(named: imageName),rect: rect,contentMode:contentMode)
    }
  
    /// 添加文本控件
    /// - Parameters:
    ///   - fontSize: 文本大小
    ///   - text: 文本
    ///   - textColor: 文本颜色
    ///   - bgColor: 背景颜色
    /// - Returns: 文本控件
     func addLabel(fontSize: CGFloat, text: String, textColor: UIColor, bgColor: UIColor) -> UILabel {
        return addLabel(font: UIFont.systemFont(ofSize: fontSize),
                           text: text,
                           textColor: textColor,
                           bgColor: bgColor)
    }
  
    /// 添加文本控件
    /// - Parameters:
    ///   - font: 文本大小
    ///   - text: 文本
    ///   - textColor: 文本颜色
    ///   - bgColor: 背景颜色
    /// - Returns: 文本控件
    func addLabel(font: UIFont, text: String, textColor: UIColor = .white, bgColor: UIColor = .clear) -> UILabel {
        let label = UILabel(frame: .zero)
        label.font = font
        label.text = text
        label.textColor = textColor
        label.backgroundColor = bgColor
        self.base.addSubview(label)
        return label
    }
  
    /// 添加按钮控件
    /// - Parameters:
    ///   - rect: 控件大小
    ///   - title: 标题
    ///   - titleColor: 标题颜色
    ///   - font: 字体
    ///   - image: 图片
    ///   - bgImg: 背景图片
    ///   - target: 事件响应者
    ///   - action: 事件响应方法
    ///   - event: 响应事件
    /// - Returns: 按钮
     func addButton(rect: CGRect, title: String, titleColor: UIColor, font: UIFont, image: UIImage?, bgImg: UIImage?, target: Any?, action: Selector?, event: UIControl.Event?) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.frame = rect
        btn.setTitle(title, for: .normal)
        btn.setTitle(title, for: .highlighted)
        btn.setTitleColor(titleColor, for: .normal)
        btn.setTitleColor(titleColor, for: .highlighted)
        btn.setImage(image, for: .normal)
        btn.setImage(image, for: .highlighted)
        btn.setBackgroundImage(bgImg, for: .normal)
        btn.setBackgroundImage(bgImg, for: .highlighted)
        btn.titleLabel?.font = font
        if let sel = action, let e = event {
            btn.addTarget(target, action: sel, for: e)
        }
        self.base.addSubview(btn)
        return btn
    }
  
    /// 添加一个文本类型的按钮控件
    /// - Parameters:
    ///   - rect: 按钮大小
    ///   - title: 文本
    ///   - titleColor: 文本颜色
    ///   - target: 事件响应者
    ///   - action: 事件响应方法
    ///   - event:响应事件
    /// - Returns: 按钮控件
    @discardableResult
     func addButton(rect: CGRect, title: String, titleColor: UIColor, target: Any?, action: Selector?, event: UIControl.Event?) -> UIButton {
        return addButton(rect: rect,
                            title: title,
                            titleColor: titleColor,
                            font: UIFont.systemFont(ofSize: 14),
                            image: nil,
                            bgImg: nil,
                            target: target,
                            action: action,
                            event: event)
    }
  
    /// 添加图片类型按钮
    /// - Parameters:
    ///   - rect: 按钮大小
    ///   - image: 图片
    ///   - target: 事件响应者
    ///   - action: 事件响应方法
    ///   - event: 响应事件
    /// - Returns: 按钮控件
     @discardableResult
     func addButton(rect: CGRect, image: UIImage, target: Any?, action: Selector?, event: UIControl.Event?) -> UIButton {
        return addButton(rect: rect,
                            title: "",
                            titleColor: .white,
                            font: UIFont.systemFont(ofSize: 14),
                            image: image,
                            bgImg: nil,
                            target: target,
                            action: action,
                            event: event)
    }
  
    /// 添加tableView
    /// - Parameters:
    ///   - rect: 大小
    ///   - delegate: delegate对象
    ///   - dataSource: dataSource 对象
    /// - Returns: 表视图
     func addTableView(rect: CGRect, delegate: UITableViewDelegate?, dataSource: UITableViewDataSource?) -> UITableView {
        let tableView = UITableView(frame: rect)
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        self.base.backgroundColor = .white
        tableView.tableFooterView = UIView()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        base.addSubview(tableView)
        return tableView
    }
    
    @discardableResult
     func addToSuperView(_ superViwe:UIView)-> ExtensionWrapper {
         superViwe.addSubview(base)
        return self
    }
    @discardableResult
    func bgColor(_ color:UIColor) -> ExtensionWrapper {
        base.backgroundColor = color
        return self
    }
    @discardableResult
    func contentMode(_ mode:UIView.ContentMode)->ExtensionWrapper {
        base.contentMode = mode
        return self
    }
    @discardableResult
    func clipsToBounds(_ clipsToBounds:Bool = true) ->ExtensionWrapper {
        base.clipsToBounds = clipsToBounds
        return self
    }
    @discardableResult
    func alpha(_ alpha:CGFloat)->ExtensionWrapper {
        base.alpha = alpha
        return self
    }
    @discardableResult
    func hidden(_ hidden:Bool) -> ExtensionWrapper {
        base.isHidden = hidden
        return self
    }
    @discardableResult
    func mask(_ maskView:UIView?) ->ExtensionWrapper {
        base.mask = maskView
        return self
    }
    @discardableResult
    func setNeedsDisplay()->ExtensionWrapper {
        base.setNeedsLayout()
        base.layoutIfNeeded()
        return self
    }
    @discardableResult
    func tag(_ tag:Int) ->ExtensionWrapper {
        base.tag = tag
        return self
    }
    @discardableResult
    func frame(_ frame:CGRect = .zero) ->ExtensionWrapper {
        base.frame = frame
        return self
    }
    @discardableResult
    func tintColor(_ tintColor:UIColor) -> ExtensionWrapper {
        base.tintColor = tintColor
        
        return self
    }
    @discardableResult
    func cornerRadius(_ cornerRadius:CGFloat) ->ExtensionWrapper {
        base.layer.cornerRadius = cornerRadius
        base.layer.masksToBounds = true
        return self
    }
    
    @discardableResult
    func removeAllSubViews()->ExtensionWrapper {
        base.subviews.forEach { sub in
            sub.removeFromSuperview()
        }
        return self
    }
    @discardableResult
    func removeSubView(_ subView:UIView) ->ExtensionWrapper {
        if base.subviews.contains(subView) {
            subView.removeFromSuperview()
        }
        return self
    }
    @discardableResult
    func makeSNP(_ closure: (_ make: ConstraintMaker) -> Void)->ExtensionWrapper{
        base.snp.makeConstraints(closure)
        return self
    }
    @discardableResult
    func addSubViews(_ subs:Array<UIView>)->ExtensionWrapper {
        subs.forEach { sub in
            base.addSubview(sub)
        }
        return self
    }
    
}


extension UIView:ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.window!
    }
    
    
}
