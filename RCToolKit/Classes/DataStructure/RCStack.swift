//
//  RCStack.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/7.
//

import Foundation

public class RCStack<T> {
    private let array: ThreadSafeArray = ThreadSafeArray<T>()
    public var size: Int { return array.count }
    public func pop() -> T? {
        if array.isEmpty { return nil }
        let e = array.last
        array.remove(at: size - 1)
        return e
    }

    public func push(e: T) {
        array.append(e)
    }
}
