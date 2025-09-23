//
//  URL+Extension.swift
//  RCToolKit
//
//  Created by yoyo on 2025/9/23.
//

import Foundation
public extension URL {
    /// 高级 URL 比较（考虑更多因素）
    func isEquivalent(to other: URL, options: ComparisonOptions = []) -> Bool {
        // 1. 基本组件比较
        guard self.scheme?.lowercased() == other.scheme?.lowercased(),
              self.host?.lowercased() == other.host?.lowercased() else {
            return false
        }
        
        // 2. 端口处理
        let selfPort = self.port ?? defaultPort(for: self.scheme)
        let otherPort = other.port ?? defaultPort(for: other.scheme)
        if selfPort != otherPort {
            return false
        }
        
        // 3. 路径标准化比较
        let selfPath = options.contains(.standardizePath) ? self.standardizedPath : self.path
        let otherPath = options.contains(.standardizePath) ? other.standardizedPath : other.path
        
        // 4. 处理尾部斜杠
        let pathEqual: Bool
        if options.contains(.ignoreTrailingSlash) {
            pathEqual = selfPath.trimmingTrailingSlash == otherPath.trimmingTrailingSlash
        } else {
            pathEqual = selfPath == otherPath
        }
        
        guard pathEqual else { return false }
        
        // 5. 查询参数比较
        if options.contains(.compareQueryParameters) {
            if !areQueryParametersEqual(to: other, options: options) {
                return false
            }
        }
        
        // 6. 片段标识符比较
        if options.contains(.compareFragment) {
            if self.fragment != other.fragment {
                return false
            }
        }
        
        return true
    }
    
    /// 比较查询参数是否相等
    private func areQueryParametersEqual(to other: URL, options: ComparisonOptions) -> Bool {
        guard let selfQuery = self.query, let otherQuery = other.query else {
            // 两个都没有查询参数
            if self.query == nil && other.query == nil {
                return true
            }
            // 一个有查询参数，一个没有
            return false
        }
        
        if options.contains(.ignoreQueryParameterOrder) {
            // 忽略参数顺序的比较
            return self.queryParameters == other.queryParameters
        } else {
            // 严格顺序比较
            return selfQuery == otherQuery
        }
    }
    
    /// 获取查询参数字典
    private var queryParameters: [String: String] {
        guard let query = self.query else { return [:] }
        
        var params = [String: String]()
        for pair in query.split(separator: "&") {
            let components = pair.split(separator: "=", maxSplits: 1)
            if components.count == 2 {
                let key = String(components[0])
                let value = String(components[1])
                params[key] = value
            }
        }
        return params
    }
    
    /// 默认端口实现（同上）
    private func defaultPort(for scheme: String?) -> Int? {
           guard let scheme = scheme else { return nil }
           
           switch scheme.lowercased() {
           case "http": return 80
           case "https": return 443
           case "ftp": return 21
           case "ssh": return 22
           default: return nil
           }
       }
    
    /// 标准化路径实现（同上）
    private var standardizedPath: String {
         let components = self.pathComponents.filter { $0 != "." }
         var result = [String]()
         
         for component in components {
             if component == ".." {
                 if !result.isEmpty {
                     result.removeLast()
                 }
             } else {
                 result.append(component)
             }
         }
         
         return "/" + result.joined(separator: "/")
     }
}

// MARK: - 比较选项
public struct  ComparisonOptions: OptionSet {
    public let rawValue: Int
    
    public  static let standardizePath = ComparisonOptions(rawValue: 1 << 0)
    public  static let ignoreTrailingSlash = ComparisonOptions(rawValue: 1 << 1)
    public static let compareQueryParameters = ComparisonOptions(rawValue: 1 << 2)
    public  static let ignoreQueryParameterOrder = ComparisonOptions(rawValue: 1 << 3)
    public  static let compareFragment = ComparisonOptions(rawValue: 1 << 4)
    
    // 常用预设
    public  static let strict: ComparisonOptions = [.standardizePath, .compareQueryParameters, .compareFragment]
    public static let relaxed: ComparisonOptions = [.standardizePath, .ignoreTrailingSlash, .ignoreQueryParameterOrder]
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

// MARK: - 字符串扩展（处理尾部斜杠）
extension String {
    var trimmingTrailingSlash: String {
        if hasSuffix("/") {
            return String(dropLast())
        }
        return self
    }
}
