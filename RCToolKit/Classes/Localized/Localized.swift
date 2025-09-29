//
//  Localized.swift
//  CocoaAsyncSocket
//
//  Created by yoyo on 2024/9/11.
//

import Foundation

var bundlePathCache: [String: String] = [:]
var bundleCache: [String: Bundle] = [:]

open class Localized {
    static var KCustomLanguageKey: String = "KCustomLanguageKey"
    static var gCustomLanguage: String?
    static var gIgnoreTraditionChinese: Bool = true
    static var gRTLOption: Bool = false
    
    open class func getLocaizedString(for key: String, in bundle: String)->String {
        return getLocaizedString(for: key, value: nil, in: bundle.rc.isEmpty ? "Main" : bundle)
    }
    
    open class func getLocaizedString(for key: String, value: String?, in bundle: String)->String {
        let language = getPreferredLanguage()
        let cacheKey = bundle + "_" + language
        var bd = bundleCache[cacheKey]
        if bundle.caseInsensitiveCompare("Main") == .orderedSame {
            bd = Bundle.main
        } else if bd == nil {
            let path = getBundlePath(bundleName: bundle, bundleKeyClass: "Localized")
            let tempbd = Bundle(path: path)?.path(forResource: language, ofType: "lproj")
            bd = Bundle(path: tempbd ?? "")
            if let db_ = bd {
                bundleCache[cacheKey] = db_
            }
        }
        if let _ = gCustomLanguage {
            if let path = bd?.path(forResource: language, ofType: "lproj") {
                bd = Bundle(path: path)
            } else {
                let path = bd?.path(forResource: "en", ofType: "lproj")
                bd = Bundle(path: path!)
            }
        }
        return NSLocalizedString(key, tableName: nil, bundle: bd!, value: value ?? "", comment: "")
    }

    open class func setCurrentLanguage(language: String) {
        UserDefaults.standard.setValue(language, forKey: KCustomLanguageKey)
        UserDefaults.standard.synchronize()
        gCustomLanguage = nil
    }
    
    open class func getPreferredLanguage() ->String {
        if gCustomLanguage == nil {
            gCustomLanguage = UserDefaults.standard.object(forKey: KCustomLanguageKey) as? String
        }
        if let gLanguage = gCustomLanguage,!gLanguage.rc.isEmpty {
            return gLanguage
        }
        var language: String? = NSLocale.preferredLanguages.first
        guard let lgg = language else {
            return "en"
        }
        if lgg.hasPrefix("en") {
            language = "en"
        } else if lgg.hasPrefix("zh") {
            if lgg.contains("Hans") {
                language = "zh-Hans"
            } else {
                language = "zh-Hant"
            }
        } else if lgg.hasPrefix("ko") {
            language = "ko"
        } else if lgg.hasPrefix("ru") {
            language = "ru"
        } else if lgg.hasPrefix("uk") {
            language = "uk"
        } else if lgg.hasPrefix("ar") {
            language = "ar"
        } else if lgg.hasPrefix("ja") {
            language = "ja"
        } else {
            language = "en"
        }
        if gIgnoreTraditionChinese, lgg.hasPrefix("zh") {
            language = "zh-Hans"
        }
        
        return language ?? "en"
    }

    open class func getBundlePath(bundleName: String, bundleKeyClass: String) ->String {
        let bundlePathKey: String = bundleName + "_" + bundleKeyClass
        var bundlePath = bundlePathCache[bundlePathKey] ?? ""
        if bundlePath.rc.isEmpty {
            bundlePath = Bundle.main.path(forResource: bundleName, ofType: "bundle") ?? ""
        }
        if bundlePath.rc.isEmpty {
            bundlePath = Bundle(for: NSClassFromString(bundleKeyClass)!).path(forResource: bundleName, ofType: "bundle") ?? ""
        }
        
        if bundlePath.rc.isEmpty {
            bundlePath = Bundle.main.bundlePath
        }
        bundlePathCache[bundlePathKey] = bundlePath
        return bundlePath
    }
}
