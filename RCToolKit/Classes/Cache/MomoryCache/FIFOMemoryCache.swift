//
//  FIFOMemoryCache.swift
//  PTChache
//
//  Created by liuming on 2021/11/18.
//

import Foundation
public class FIFOMemoryCache: PTBaseCache {
    override public func onMomeryWarring() {
        // 每次触发 onMomeryWarring 则将缓存降低到 maxCacheSize 的 三分之二
        let willDeleteSize = currentCacheSize - (maxCacheSize * 2 / 3)
        var deletedSize: UInt32 = 0
        while willDeleteSize > deletedSize {
            var deleteNodel = cacheHeader.next()
            if deleteNodel?.next() == nil {
                break
            }
            if let node = deleteNodel {
                delete(key: node.key!.cacheKey())
                deletedSize += node.size
            }
            deleteNodel = deleteNodel!.next()
        }
    }
}
