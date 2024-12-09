//
//  UIDevice+Extension.swift
//  RCToolKit
//
//  Created by yoyo on 2023/3/23.
//

import Foundation

public extension ExtensionWrapper where Base == UIDevice.Type {
    var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            let keyWindow = UIApplication.shared.connectedScenes
                .map { $0 as? UIWindowScene }
                .compactMap { $0 }
                .first?.windows.first ?? UIApplication.shared.keyWindow
            return keyWindow
        } else {
            return UIApplication.shared.keyWindow
        }
    }

    var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    func safeDistanceTop() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.top
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return 0 }
            return window.safeAreaInsets.top
        }
        return 0
    }
    
    /// 底部安全区高度
    func safeDistanceBottom() -> CGFloat {
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let window = windowScene.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return 0 }
            return window.safeAreaInsets.bottom
        }
        return 0
    }
    
    /// 顶部状态栏高度（包括安全区）
    func statusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return 0 }
            guard let statusBarManager = windowScene.statusBarManager else { return 0 }
            statusBarHeight = statusBarManager.statusBarFrame.height
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
    
    /// 导航栏高度
    func navigationBarHeight() -> CGFloat {
        44.0
    }
    
    /// 状态栏+导航栏的高度
    func navigationFullHeight() -> CGFloat {
        statusBarHeight() + navigationBarHeight()
    }
    
    /// 底部导航栏高度
    func tabBarHeight() -> CGFloat {
        49.0
    }
    
    /// 底部导航栏高度（包括安全区）
    func tabBarFullHeight() -> CGFloat {
        tabBarHeight() + safeDistanceBottom()
    }
    
    func platformInfo() -> String {
        "\(base.current.systemName) \(base.current.systemVersion)"
    }
    
    func appName() -> String {
        let infoDic = Bundle.main.infoDictionary
        return infoDic?["CFBundleDisplayName"] as? String ?? "unknow"
    }

    func appVersion() -> String {
        let infoDic = Bundle.main.infoDictionary
        let shortVersion = infoDic?["CFBundleShortVersionString"] ?? "unhnow"
        let buildVersion = infoDic?["CFBundleVersion"] ?? "unhnow"
        return "\(shortVersion).\(buildVersion)"
    }

    func deviceInfo() -> String {
        base.current.localizedModel
    }

    func deviceUniqueID() -> String {
        guard let uuid = base.current.identifierForVendor?.uuidString else {
            return "unknow"
        }
        return uuid.md5
    }

    func getAgent() -> String {
       return  "iOS|\(platformInfo())|\(deviceInfo())|\(deviceInfo())|\(appName())|\(appVersion())"
    }
}
