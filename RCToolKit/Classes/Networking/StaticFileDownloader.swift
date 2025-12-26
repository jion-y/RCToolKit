//
//  StaticFileDownloader.swift
//  RCToolKit
//
//  Created by yoyo on 2025/9/8.
//

import Foundation
open class StaticFileDownloader {
    public var ignorEtag:Bool
    private var cache: RCCache
    public init(ignorEtag: Bool = false, cache: RCCache =  .init(type: .disk, policy: .LRU)) {
        self.ignorEtag = ignorEtag
        self.cache = cache
    }
    public func downloadFile(from url: URL, to destination: URL? = nil) async -> Data? {
        var data: Data?
        if await shouldDownload(from: url) {
            data = try? await startDownloadFile(from: url, to: destination)
        } else {
            data = getData(url: url)
            if let d = data, d.isEmpty {
                data = try? await startDownloadFile(from: url, to: destination)
            }
        }
        return data
    }
    
    func getBaseURL(from url: URL) -> String? {
        #if false
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil // URL 格式无效
        }
        
        // 重组 scheme、host、path（忽略 query、fragment 等）
        var baseComponents = URLComponents()
        baseComponents.scheme = components.scheme
        baseComponents.host = components.host
        baseComponents.path = components.path
        
        return baseComponents.url?.absoluteString
        #else
        return url.absoluteString
        #endif
    }
    
    /// 检查是否需要下载文件
    /// - Parameters:
    ///   - localPath: 本地文件路径
    ///   - cloudMD5: 云端文件 MD5
    /// - Returns: 是否需要下载（true: 需要下载，false: 使用本地）
    func shouldDownload(from url: URL) async -> Bool {
        let value = getEtagValue(url: url)
        if value.isEmpty { return true }
        if self.ignorEtag {  return false }
        do {
            var eTag: String? = try await fetchETagViaHEAD(from: url)
            return eTag != value
            
        } catch {
            RCLog.rc.logE(message: " Get Etag Error \(error) url = \(url.absoluteString)")
        }
        return true
    }
        
    /// 通过 HEAD 请求获取云端文件的 ETag（不下载文件内容）
    /// - Parameter url: 云端文件 URL
    /// - Returns: ETag 字符串（去除引号），失败返回 nil
    func fetchETagViaHEAD(from url: URL) async throws -> String? {
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        let t1 = Date().timeIntervalSince1970
        // 1. 发送 HEAD 请求，获取响应（可能为 nil）
        let (data, response) = try await URLSession.shared.data(for: request)
        let t2 = Date().timeIntervalSince1970
        // response \(response)
        RCLog.rc.logD(message: "HEAD Request \(url.absoluteString)  data size \(data.count)  cost time \(t2 - t1) ")
        // 2. 尝试转换为 HTTPURLResponse（仅 HTTP 响应有 status_code）
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(
                domain: "ETagFetchError",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: "非 HTTP 响应类型（如 FTP）"]
            )
        }
        
        // 3. 检查 HTTP 状态码是否为 200（成功）
        guard httpResponse.statusCode == 200 else {
            // 此时 httpResponse 是确定的 HTTPURLResponse，可安全访问 statusCode
            throw NSError(
                domain: "ETagFetchError",
                code: -3,
                userInfo: [NSLocalizedDescriptionKey: "HEAD 请求失败，状态码：\(httpResponse.statusCode)"]
            )
        }
        
        // 5. 提取 ETag（去除引号）
        guard let eTag = httpResponse.allHeaderFields["Etag"] as? String else {
            return nil // 服务器未返回 ETag
        }
        let rst = eTag.trimmingCharacters(in: .init(charactersIn: "\""))
        RCLog.rc.logInfo(message: " \(url.absoluteString)  Etag value \(rst)  ")
        return rst
    }
    
    func startDownloadFile(from url: URL, to destination: URL?) async throws -> Data? {
        do {
            let condig = URLSessionConfiguration.default
            condig.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            let (data, response) = try await URLSession(configuration: condig).data(for: URLRequest(url: url))
            guard let httpResponse = response as? HTTPURLResponse,
                  (200 ... 299).contains(httpResponse.statusCode)
            else {
                throw NSError(
                    domain: "DownloadError",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: "无效的 HTTP 响应"]
                )
            }
            if let eTag = httpResponse.allHeaderFields["Etag"] as? String {
                let str = eTag.trimmingCharacters(in: .init(charactersIn: "\""))
                updateEtag(url: url, value: str)
            }
            if let destination = destination {
                // 3. 清理目标路径已存在的文件（若需要）
                if FileManager.default.fileExists(atPath: destination.path) {
                    try FileManager.default.removeItem(at: destination)
                }
                try? data.write(to: destination, options: .atomic)
            }
            updateData(url: url, value: data)
            return data
    
        } catch {
            return nil
        }
    }
    
    private func updateEtag(url: URL, value: String) {
        let key = ( getBaseURL(from: url) ?? "DefaultEtag") + "_Etag"
        cache.cache(value, for: key)
    }

    private func getEtagValue(url: URL) -> String {
        let key = ( getBaseURL(from: url) ?? "DefaultEtag") + "_Etag"
        var value = ""
        value = cache.getValue(key) ?? ""
        return value
    }
    
    private func updateData(url: URL, value: Data) {
        let key = ( getBaseURL(from: url) ?? "DefaultData" )
        
        RCLog.rc.logInfo(message: " url : \(url.absoluteString)  data \(String(data:value,encoding: .utf8))")
        cache.cache(value, for: key)
    }

    private func getData(url: URL) -> Data {
        let key = ( getBaseURL(from: url) ?? "DefaultData" )
        var value = Data()
        value = cache.getValue(key) ?? Data()
        return value
    }
    
}
