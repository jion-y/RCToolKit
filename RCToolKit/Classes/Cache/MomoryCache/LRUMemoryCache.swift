//
//  LRUMemoryCache.swift
//  PTChache
//
//  Created by liuming on 2021/11/18.
//

import Foundation

public class LRUMemoryCache: PTBaseCache {
    override public func insterNode(_ node: CacheNode) {
        let nextNode = cacheHeader.next()
        if nextNode == nil {
            cacheHeader.setup(prev: nil, next: node)
            node.setup(prev: cacheHeader, next: endNode)
            endNode.setup(prev: node, next: nil)
            return
        }
        cacheHeader.setup(prev: nil, next: node)
        node.setup(prev: cacheHeader, next: nextNode)
        nextNode?.setup(prev: node, next: nextNode?.next())
    }

    override public func cacheFor<K, V>(key: K) -> V? where K: KeyEnable, V: ValueEnable {
        let node = cacheMap[key.cacheKey()]
        guard let n = node else { return nil }
        deleteNode(n)
        insterNode(n)
        return n.data as? V
    }

    override public func onMomeryWarring() {
        // 每次触发 onMomeryWarring 则将缓存降低到 maxCacheSize 的 三分之二
        let willDeleteSize = currentCacheSize - (maxCacheSize * 2 / 3)
        var deletedSize: UInt32 = 0
        while willDeleteSize > deletedSize {
            var deleteNodel = endNode.prev()
            if deleteNodel == nil || deleteNodel?.prev() == nil {
                break
            }
            delete(key: deleteNodel!.key!.cacheKey())
            deletedSize += deleteNodel!.size
            deleteNodel = endNode.prev()
        }
    }
}
