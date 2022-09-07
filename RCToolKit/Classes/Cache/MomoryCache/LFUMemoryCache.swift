//
//  LFUMemoryCache.swift
//  PTChache
//
//  Created by liuming on 2021/11/18.
//

import Foundation
public class LFUMemoryCache: PTBaseCache {
    private var keyToFreqMap: [String: Int] = [:]
    private var freqToKeys: [Int: [String]] = [:]

    override public func cacheFor<K, V>(key: K) -> V? where K: KeyEnable, V: ValueEnable {
        let node = cacheMap[key.cacheKey()]
        guard let n = node else { return nil }
        // 维护
        var freq: Int = keyToFreqMap[key.cacheKey()] ?? 0
        // 删除旧的记录
        var array: [String] = freqToKeys[freq] ?? []
        if !array.contains(key.cacheKey()) {
            array.removeAll { k in
                k == key.cacheKey()
            }
        }
        freqToKeys[0] = array
        // 添加新纪录
        freq += 1
        keyToFreqMap[key.cacheKey()] = freq
        array = freqToKeys[freq] ?? []
        if !array.contains(key.cacheKey()) {
            array.append(key.cacheKey())
        }
        freqToKeys[freq] = array
        return n.data as? V
    }

    override public func cache<K, V>(key: K, value: V) where K: KeyEnable, V: ValueEnable {
        if let node = cacheMap[key.cacheKey()] {
            currentCacheSize -= node.size
            node.update(value: value)
            currentCacheSize += node.size
            return
        }
        let node = CacheNode(key: key, value: value)
        insterNode(node)
        cacheMap[key.cacheKey()] = node
        currentCacheSize += node.size
        keyToFreqMap[key.cacheKey()] = 0
        var array: [String] = freqToKeys[0] ?? []
        if !array.contains(key.cacheKey()) {
            array.append(key.cacheKey())
        }
        freqToKeys[0] = array
    }
    
    public override func delete(key: String) {
        if let node = cacheMap[key] {
            deleteNode(node)
            cacheMap.removeValue(forKey: key.cacheKey())
            
            let freq = self.keyToFreqMap[key]!
            var keyList = self.freqToKeys[freq]!
            keyList.removeAll { removeKey in
                key == removeKey
            }
            self.keyToFreqMap.removeValue(forKey: key)
            currentCacheSize -= node.size
            return
        }
    }

    override public func onMomeryWarring() {
        // 每次触发 onMomeryWarring 则将缓存降低到 maxCacheSize 的 三分之二
        let willDeleteSize = currentCacheSize - (maxCacheSize * 2 / 3)
        var deletedSize: UInt32 = 0

        let freqArray = keyToFreqMap.values
        let sortFreqArray = freqArray.sorted()
        var deleteKeys: [String] = []
        sortFreqArray.forEach { freq in
            let keys = self.freqToKeys[freq]!
            keys.forEach { key in
                if willDeleteSize > deletedSize {
                    let node = self.cacheMap[key]
                    delete(key: key)
                    deletedSize += node?.size ?? 0
                    deleteKeys.append(key)
                }
            }
        }
        // 移出已经被删除的 key
        deleteKeys.forEach { key in
            let freq = self.keyToFreqMap[key]!
            var keyList = self.freqToKeys[freq]!
            keyList.removeAll { removeKey in
                key == removeKey
            }
            self.keyToFreqMap.removeValue(forKey: key)
        }
    }
}
