//
//  FIFODiskCache.swift
//  PTChache
//
//  Created by liuming on 2021/11/18.
//

import Foundation

public class DiskCache: PTBaseCache {
    override public func cacheFor<K, V>(key: K) -> V? where K: KeyEnable, V: ValueEnable {
        let cacheFilePath = fileFullPath(fileName: fileName(with: key))
        if existFile(path: cacheFilePath) {
            let url = URL(fileURLWithPath: cacheFilePath)
            do {
                let data = try Data(contentsOf: url)
                let decorderData =  try data.rc.decrypt(keyStr: self.aesKey)
                let value = V.decode(data: decorderData)
                return value as? V
            } catch {
                print(" cache key \(key.cacheKey()) file failure  error \(error)")
            }
        }
        return nil
    }

    override public func cache<K, V>(key: K, value: V) where K: KeyEnable, V: ValueEnable {
        let cacheFilePath = fileFullPath(fileName: fileName(with: key))
        guard let data = value.encode() else {
            if existFile(path: cacheFilePath) {
                deletePath(path: cacheFilePath)
            }
            return
        }
        do {
            let encoderData = try data.rc.aesEncrypt(keyStr: self.aesKey)
            try encoderData.write(to: URL(fileURLWithPath: cacheFilePath))
        } catch {
            print(" cache key \(key.cacheKey()) file failure  error \(error)")
        }
        currentCacheSize += UInt32(data.count)
    }

    override public func delete(key: String) {
        let cacheFilePath = fileFullPath(fileName: key.md5)
        deletePath(path: cacheFilePath)
    }

    override public func onMomeryWarring() {
        currentCacheSize = 0
        deletePath(path: cacheDir)
    }
}

// 文件操作
extension DiskCache {
    private func fileName<K: KeyEnable>(with key: K) -> String {
        return key.cacheKey().md5
    }

    private func fileFullPath(fileName: String) -> String {
        let c = cacheDir.last
        if c != "/" {
            cacheDir.append("/")
        }
        return cacheDir + fileName
    }

    private func existFile(path: String) -> Bool {
        return FileManager.default.rc.fileExist(atPath: path)
    }

    private func deletePath(path: String) {
        _ = FileManager.default.rc.deleteItem(at: path)
    }
}
