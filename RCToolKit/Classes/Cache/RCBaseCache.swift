//
//  PTBaseCache.swift
//  PTChache
//
//  Created by liuming on 2021/11/18.
//

import Foundation
//// K: KeyEnable, V: ValueEnable
public class PTBaseCache {
    
    public var aesKey:String = "com.toolkit.cache"
    /// 最大混存大小
    public var maxCacheSize: UInt32 = 0

    private var _cacheDir: String = ""
    /// 缓存路径:只针对磁盘了有效
    public var cacheDir: String {
        set {
            if newValue != _cacheDir {
                _cacheDir = newValue
                let _ = FileManager.default.rc.createDirectory(_cacheDir)
            }
            currentCacheSize = FileManager.default.rc.directorySize(_cacheDir)
        }
        get {
            return _cacheDir
        }
    }

    public var currentCacheSize: UInt32 = 0 {
        didSet {
            if currentCacheSize >= maxCacheSize {
                onMomeryWarring()
            }
        }
    }

    public var cacheMap: [String: CacheNode] = [:]

    // 链表结构头结点
    public var cacheHeader = CacheNode(key: nil, value: nil)
    // 最后一个节点
    public var endNode = CacheNode(key: nil, value: nil)

    public func cache<K: KeyEnable, V: ValueEnable>(key: K, value: V) {
        if let node = cacheMap[key.cacheKey()] {
            currentCacheSize = max(currentCacheSize - node.size, 0)
            node.update(value: value)
            currentCacheSize += node.size
            return
        }
        let node = CacheNode(key: key, value: value)
        insterNode(node)
        cacheMap[key.cacheKey()] = node
        currentCacheSize += node.size
    }

    public func cacheFor<K: KeyEnable, V: ValueEnable>(key: K) -> V? {
        let node = cacheMap[key.cacheKey()]
        guard let n = node else { return nil }
        return n.data as? V
    }

    public func delete(key: String) {
        if let node = cacheMap[key] {
            deleteNode(node)
            cacheMap.removeValue(forKey: key.cacheKey())
            currentCacheSize -= node.size
            return
        }
    }

    public func cacheSize() -> UInt32 {
        return currentCacheSize
    }

    public func onMomeryWarring() {}

    // 链表操作 子类重写
    public func insterNode(_ node: CacheNode) {
        let prevNode = endNode.prev()
        if prevNode != nil {
            prevNode?.setup(prev: prevNode?.prev(), next: node)
            node.setup(prev: prevNode, next: endNode)
            endNode.setup(prev: node, next: nil)
            return
        }
        cacheHeader.setup(prev: nil, next: node)
        node.setup(prev: cacheHeader, next: nil)
        endNode.setup(prev: node, next: nil)
    }

    public func deleteNode(_ node: CacheNode) {
        let preNode = node.prev()
        let nextNode = node.next()
        preNode?.setup(prev: preNode?.prev(), next: nextNode)
        nextNode?.setup(prev: preNode, next: nextNode?.next())
        node.setup(prev: nil, next: nil)
    }
}
