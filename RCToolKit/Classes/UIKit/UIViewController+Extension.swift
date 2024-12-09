//
//  UIViewController+Extension.swift
//  RCToolKit
//
//  Created by yoyo on 2024/11/5.
//

import Foundation
import UIKit
extension UIViewController: ExtensionCompatibleValue {}

public extension ExtensionWrapper where Base: UIViewController {
    
}

public extension ExtensionWrapper where Base == UIViewController.Type {
    /// 获取当前显示的VC
    ///
    /// - Returns: 当前屏幕显示的VC
    func getCurrentViewController() -> UIViewController?{
        // 获取当先显示的window
        var currentWindow = UIDevice.rc.keyWindow ?? UIWindow()
        if currentWindow.windowLevel != UIWindow.Level.normal {
            let windowArr = UIApplication.shared.windows
            for window in windowArr {
                if window.windowLevel == UIWindow.Level.normal {
                    currentWindow = window
                    break
                }
            }
        }
        return getNextXController(nextController: currentWindow.rootViewController)
    }
    
    private  func  getNextXController(nextController: UIViewController?) -> UIViewController? {
        if nextController == nil {
            return nil
        }else if nextController?.presentedViewController != nil {
            return getNextXController(nextController: nextController?.presentedViewController)
        }else if let tabbar = nextController as? UITabBarController {
            return getNextXController(nextController: tabbar.selectedViewController)
        }else if let nav = nextController as? UINavigationController {
            return getNextXController(nextController: nav.visibleViewController)
        }
        return nextController
    }
}
