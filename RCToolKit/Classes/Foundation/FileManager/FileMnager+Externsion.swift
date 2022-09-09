//
//  FileMnager+Externsion.swift
//  Pods-PTCommonPlugins_Example
//
//  Created by liuming on 2021/11/22.
//

import Foundation
public extension ExtensionWrapper where Base == FileManager {
    func createDirectory(_ path: String) ->Bool {
        var isDir: ObjCBool = false
        let existed = self.base.fileExists(atPath: path, isDirectory: &isDir)
        if !(isDir.boolValue == true && existed == true) {
            do {
                try self.base.createDirectory(at: URL(fileURLWithPath: path), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("create dirctory at \(path) error  error info:\(error)")
                return false
            }
        }
        return true
    }

    func fileExist(atPath path: String)->Bool {
        return self.base.fileExists(atPath: path)
    }

    func deleteItem(at path: String)->Bool {
        do {
            try self.base.removeItem(at: URL(fileURLWithPath: path))
        } catch (_) {
            return false
        }
        return true
    }

    func directorySize(_ path: String)->UInt32 {
        guard let files = self.base.subpaths(atPath: path) else {
            return 0
        }
        var totalSize: UInt32 = 0
        files.forEach { filePath in
            totalSize += fileSize(filePath)
        }
        return totalSize
    }

    func fileSize(_ path: String)->UInt32 {
        // 获取当前目录缓存大小
        do {
            let result = try FileManager.default.attributesOfItem(atPath: path)
            guard let size = result[FileAttributeKey.size] as? UInt32 else {
                return 0
            }
            return size
        } catch {
            print(" get cache file size error \(error)")
        }
        return 0
    }
    func documentPath()->String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ??  String.rc.empty
    }
    func libraryPath()->String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first ?? String.rc.empty
    }
    func cachePath()->String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? String.rc.empty
    }
    func tempPath()->String {
        return NSTemporaryDirectory()
    }
}
