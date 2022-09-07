//
//  CacheNode.swift
//  PTChache
//
//  Created by liuming on 2021/11/18.
//

import Foundation

public class CacheNode: Equatable {
    public static func == (_: CacheNode, _: CacheNode) -> Bool {
        return false
    }

    public var key: KeyEnable?
    public var data: ValueEnable?

    public var size: UInt32 = 0

    private var prevNode: CacheNode?
    private var nextNode: CacheNode?
    private var time: TimeInterval = 0
    init(key: KeyEnable?, value: ValueEnable?) {
        self.key = key
        update(value: value)
    }
}

public extension CacheNode {
    func update(value: ValueEnable?) {
        guard let v = value else {
            return
        }
        if let data = v.encode() {
            size = UInt32(data.count)
        }
        data = v
        time = Date().timeIntervalSince1970
    }

    func setup(prev: CacheNode? = nil, next: CacheNode? = nil) {
        prevNode = prev
        nextNode = next
    }

    func next() -> CacheNode? {
        return nextNode
    }

    func prev() -> CacheNode? {
        return prevNode
    }

    func isHeader() -> Bool {
        let hasPrev = prevNode == nil ? false : true
        let hasNext = nextNode == nil ? false : true
        return !hasPrev && hasNext
    }

    func isEnd() -> Bool {
        let hasPrev = prevNode == nil ? false : true
        let hasNext = nextNode == nil ? false : true
        return hasPrev && !hasNext
    }
}
