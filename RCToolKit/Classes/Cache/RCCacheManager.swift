//
//  PTChace.swift
//  Pods-PTChache_Example
//
//  Created by liuming on 2021/11/18.
//

import CommonCrypto
import Foundation
import UIKit
import CryptoKit

// MARK: - KeyEnable

public protocol KeyEnable {
    func cacheKey() -> String
}

// MARK: - ValueEnable

public protocol ValueEnable {
    static func decode(data: Data) -> ValueEnable?
    func encode() -> Data?
}

// MARK: - PTCacheType

/// 缓存内存，支持内存缓存和文件缓存
public enum PTCacheType: Int {
    case momery = 0
    case disk = 1
    case all = 2
}

// MARK: - PTCachePolicy

public enum PTCachePolicy: Int {
    case FIFO = 0 // 先进先出策略
    case LFU = 1 // 最少使用策略
    case LRU = 2 // 最近最少使用策略
}

// MARK: - Cahche

// K 建议用 string
public class Cahche {
    public var aesKey:String = "com.toolkit.cache"
    /// 内存缓存大小，默认 50M
    public var momeryCacheSize: UInt32 = 1024 * 1024 * 50 {
        didSet {
            configCache()
        }
    }

    /// 磁盘缓存大小，默认100M
    public var diskCacheSize: UInt32 = 1024 * 1024 * 100 {
        didSet {
            configCache()
        }
    }

    /// 磁盘文件缓存路径
    public var cachePath: String? {
        didSet {
            configCache()
        }
    }

    /// 缓存类型，默认内存缓存
    private var cacheType: PTCacheType = .momery
    /// 缓存策略,默认FIFO策略
    private var policy: PTCachePolicy = .FIFO

    private var momeryCache: PTBaseCache?
    private var diskCache: PTBaseCache?

    public init(type: PTCacheType = .momery,
                policy: PTCachePolicy = .FIFO)
    {
        cacheType = type
        self.policy = policy
        setupCache(type: type, policy: policy)
        configCache()
    }

    private func setupCache(type: PTCacheType, policy: PTCachePolicy) {
        switch type {
        case .momery:
            momeryCache = getMomoryCache(policy: policy)
        case .disk:
            diskCache = getDiskCache(policy: policy)
        case .all:
            momeryCache = getMomoryCache(policy: policy)
            diskCache = getDiskCache(policy: policy)
        }
    }

    private func configCache() {
        momeryCache?.maxCacheSize = momeryCacheSize
        diskCache?.maxCacheSize = diskCacheSize
        let cacheDir = cachePath ?? defaultCachePath()
        diskCache?.cacheDir = cacheDir
    }
}

// MARK: - extension Cache func

public extension Cahche {
    func cache<K: KeyEnable, V: ValueEnable>(_ value: V, for key: K) {
        if cacheType == .all || cacheType == .momery {
            momeryCache?.cache(key: key, value: value)
        }
        if cacheType == .all || cacheType == .disk {
            diskCache?.cache(key: key, value: value)
        }
    }

    func getValue<K: KeyEnable, V: ValueEnable>(_ key: K, model _: V) -> V? {
        if cacheType == .all {
            var momeryCacheResult: V?
            var diskCacheResult: V?
            momeryCacheResult = momeryCache?.cacheFor(key: key)
            guard let m_result = momeryCacheResult else {
                diskCacheResult = diskCache?.cacheFor(key: key)
                if let disk_result = diskCacheResult {
                    momeryCache?.cache(key: key, value: disk_result)
                }
                return diskCacheResult
            }
            diskCache?.cache(key: key, value: m_result)
            return m_result
        }

        if cacheType == .momery {
            return momeryCache?.cacheFor(key: key)
        }
        if cacheType == .disk {
            return diskCache?.cacheFor(key: key)
        }
        return nil
    }

    func delete<K: KeyEnable>(_ key: K) {
        momeryCache?.delete(key: key.cacheKey())
        diskCache?.delete(key: key.cacheKey())
    }
}

// MARK: - extension private func

extension Cahche {
    private func getMomoryCache(policy: PTCachePolicy) -> PTBaseCache? {
        switch policy {
        case .FIFO:
            let cache =  FIFOMemoryCache()
            cache.aesKey = self.aesKey
            return cache
        case .LFU:
            let cache =  LFUMemoryCache()
            cache.aesKey = self.aesKey
            return cache
        case .LRU:
            let cache =  LRUMemoryCache()
            cache.aesKey = self.aesKey
            return cache
        }
    }

    private func getDiskCache(policy _: PTCachePolicy) -> PTBaseCache? {
        let cache =  DiskCache()
        cache.aesKey = self.aesKey
        return cache
    }

    private func defaultCachePath() -> String {
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        let documentPath = documentPaths.first ?? ""
        return documentPath + "/com.rc.cache/cache/"
    }
}

// MARK: - String + KeyEnable

extension String: KeyEnable {
    public func cacheKey() -> String {
        return self
    }
}

// MARK: - UIImage + ValueEnable

extension UIImage: ValueEnable {
    public func encode() -> Data? {
        return self.jpegData(compressionQuality: 0.9)
    }

    public static func decode(data: Data) -> ValueEnable? {
        return UIImage(data: data)
    }
}

// MARK: - Data + ValueEnable

extension Data: ValueEnable {
    public static func decode(data: Data) -> ValueEnable? {
        return data
    }

    public func encode() -> Data? {
        return self
    }
}

// MARK: - String + ValueEnable

extension String: ValueEnable {
    public static func decode(data: Data) -> ValueEnable? {
        return String(data: data, encoding: .utf8)
    }

    public func encode() -> Data? {
        
        return data(using: .utf8)
    }
}

// extension Data:ValueEnable{}

public extension String {
    // ##################################################################
    /// - returns: the String, as an MD5 hash.
    var md5: String {
        let str = cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)

        let hash = NSMutableString()

        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }

        result.deallocate()
        return hash as String
    }
}

// MARK: - Int + ValueEnable

extension Int: ValueEnable {
    public static func decode(data: Data) -> ValueEnable? {
        let str = String(data: data, encoding: .utf8) ?? "0"
        return Int(str)
    }

    public func encode() -> Data? {
        return ("\(self)").data(using: .utf8)
    }
}
