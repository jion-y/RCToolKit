//
//  AppInfo.swift
//  Alamofire
//
//  Created by yoyo on 2024/10/21.
//

import Foundation
open class AppInfo {
    open class func getAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
    open class func getAppName()->String {
         return  Bundle.main.infoDictionary!["CFBundleDisplayName"] as! String
        
    }
}
