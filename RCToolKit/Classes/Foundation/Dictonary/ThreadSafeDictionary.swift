//
//  SafeDictionary.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/8.
//

import Foundation
public class ThreadSafeDictionary<Key, Value> where Key: Hashable {
    private var dic: [Key: Value] = [:]
    private var lock = pthread_rwlock_t()

    public init() {
        let status = pthread_rwlock_init(&lock, nil)
        assert(status == 0)
    }

    public convenience init(dic: [Key: Value]) {
        self.init()
        self.dic = dic
    }

    deinit {
        pthread_rwlock_destroy(&lock)
    }
}

public extension ThreadSafeDictionary {
    subscript(key: Key) -> Value? {
        get {
            pthread_rwlock_rdlock(&lock)
            let value = dic[key]
            pthread_rwlock_unlock(&lock)
            return value
        }
        set {
            guard let value = newValue else { return }
            pthread_rwlock_wrlock(&lock)
            dic[key] = value
            pthread_rwlock_unlock(&lock)
        }
    }

    internal subscript(key: Key, default defaultValue: @autoclosure () -> Value) -> Value {
        pthread_rwlock_rdlock(&lock)
        let value = dic[key] ?? defaultValue()
        pthread_rwlock_unlock(&lock)
        return value
    }

    func mapValues<T>(_ transform: (Value) throws -> T) rethrows -> [Key: T] {
        pthread_rwlock_rdlock(&lock)
        do {
            let value = try dic.mapValues(transform)
            pthread_rwlock_unlock(&lock)
            return value
        } catch {
            pthread_rwlock_unlock(&lock)
            throw error
        }
    }

    func compactMapValues<T>(_ transform: (Value) throws -> T?) rethrows -> [Key: T] {
        pthread_rwlock_rdlock(&lock)
        do {
            let value = try dic.compactMapValues(transform)
            pthread_rwlock_unlock(&lock)
            return value
        } catch {
            pthread_rwlock_unlock(&lock)
            throw error
        }
    }

    func updateValue(_ value: Value, forKey key: Key) -> Value? {
        pthread_rwlock_wrlock(&lock)
        let rst = dic.updateValue(value, forKey: key)
        pthread_rwlock_unlock(&lock)
        return rst
    }

    func merge<S>(_ other: S, uniquingKeysWith combine: (Value, Value) throws -> Value) rethrows where S: Sequence, S.Element == (Key, Value) {
        pthread_rwlock_wrlock(&lock)
        do {
            try dic.merge(other, uniquingKeysWith: combine)
            pthread_rwlock_unlock(&lock)
        } catch {
            pthread_rwlock_unlock(&lock)
            throw error
        }
    }

    func merge(_ other: [Key: Value], uniquingKeysWith combine: (Value, Value) throws -> Value) rethrows {
        pthread_rwlock_wrlock(&lock)
        do {
            try dic.merge(other, uniquingKeysWith: combine)
            pthread_rwlock_unlock(&lock)
        } catch {
            pthread_rwlock_unlock(&lock)
            throw error
        }
    }

    func merging<S>(_ other: S, uniquingKeysWith combine: (Value, Value) throws -> Value) rethrows -> [Key: Value] where S: Sequence, S.Element == (Key, Value) {
        pthread_rwlock_wrlock(&lock)
        do {
            let rst = try dic.merging(other, uniquingKeysWith: combine)
            pthread_rwlock_unlock(&lock)
            return rst
        } catch {
            pthread_rwlock_unlock(&lock)
            throw error
        }
    }

    func merging(_ other: [Key: Value], uniquingKeysWith combine: (Value, Value) throws -> Value) rethrows -> [Key: Value] {
        pthread_rwlock_wrlock(&lock)
        do {
            let rst = try dic.merging(other, uniquingKeysWith: combine)
            pthread_rwlock_unlock(&lock)
            return rst
        } catch {
            pthread_rwlock_unlock(&lock)
            throw error
        }
    }

    func remove(at index: Dictionary<Key, Value>.Index) -> Dictionary<Key, Value>.Element {
        pthread_rwlock_wrlock(&lock)
        let rst = dic.remove(at: index)
        pthread_rwlock_unlock(&lock)
        return rst
    }
    @discardableResult
    func removeValue(forKey key: Key) -> Value? {
        pthread_rwlock_wrlock(&lock)
        let rst = dic.removeValue(forKey: key)
        pthread_rwlock_unlock(&lock)
        return rst
    }

    func removeAll(keepingCapacity keepCapacity: Bool = false) {
        pthread_rwlock_wrlock(&lock)
        dic.removeAll(keepingCapacity: keepCapacity)
        pthread_rwlock_unlock(&lock)
    }

    var keys: Dictionary<Key, Value>.Keys { return dic.keys }
    var values: Dictionary<Key, Value>.Values { return dic.values }

    func popFirst() -> Dictionary<Key, Value>.Element? {
        pthread_rwlock_wrlock(&lock)
        let rst = dic.popFirst()
        pthread_rwlock_unlock(&lock)
        return rst
    }

    func map<T>(_ transform: ((key: Key, value: Value)) throws -> T) rethrows -> [T] {
        pthread_rwlock_rdlock(&lock)
        do {
            let rst = try dic.map(transform)
            pthread_rwlock_unlock(&lock)
            return rst
        } catch {
            pthread_rwlock_unlock(&lock)
            throw error
        }
    }

    func dropFirst(_ k: Int = 1) -> Slice<[Key: Value]> {
        pthread_rwlock_wrlock(&lock)
        let rst = dic.dropFirst(k)
        pthread_rwlock_unlock(&lock)
        return rst
    }

    func dropLast(_ k: Int = 1) -> Slice<[Key: Value]> {
        pthread_rwlock_wrlock(&lock)
        let rst = dic.dropLast(k)
        pthread_rwlock_unlock(&lock)
        return rst
    }

    func drop(while predicate: ((key: Key, value: Value)) throws -> Bool) rethrows -> Slice<[Key: Value]> {
        pthread_rwlock_wrlock(&lock)
        do {
            let rst = try dic.drop(while: predicate)
            pthread_rwlock_unlock(&lock)
            return rst
        } catch {
            pthread_rwlock_unlock(&lock)
            throw error
        }
    }

    func prefix(_ maxLength: Int) -> Slice<[Key: Value]> {
        pthread_rwlock_rdlock(&lock)
        let rst = dic.prefix(maxLength)
        pthread_rwlock_unlock(&lock)
        return rst
    }

    func prefix(while predicate: ((key: Key, value: Value)) throws -> Bool) rethrows -> Slice<[Key: Value]> {
        pthread_rwlock_rdlock(&lock)
        do {
            let rst = try dic.prefix(while: predicate)
            pthread_rwlock_unlock(&lock)
            return rst
        } catch {
            pthread_rwlock_unlock(&lock)
            throw error
        }
    }

    func suffix(_ maxLength: Int) -> Slice<[Key: Value]> {
        pthread_rwlock_rdlock(&lock)
        let rst = dic.suffix(maxLength)
        pthread_rwlock_unlock(&lock)
        return rst
    }

    func prefix(upTo end: Dictionary<Key, Value>.Index) -> Slice<[Key: Value]> {
        pthread_rwlock_rdlock(&lock)
        let rst = dic.prefix(upTo: end)
        pthread_rwlock_unlock(&lock)
        return rst
    }

    func suffix(from start: Dictionary<Key, Value>.Index) -> Slice<[Key: Value]> {
        pthread_rwlock_rdlock(&lock)
        let rst = dic.suffix(from: start)
        pthread_rwlock_unlock(&lock)
        return rst
    }

    subscript<R>(r: R) -> Slice<[Key: Value]> where R: RangeExpression, Dictionary<Key, Value>.Index == R.Bound { return dic[r] }

    internal subscript(x: (UnboundedRange_) -> Void) -> Slice<[Key: Value]> { return dic[x] }

    func forEach(_ body: ((key: Key, value: Value)) throws -> Void) rethrows {
        pthread_rwlock_rdlock(&lock)
        do {
            try dic.forEach(body)
            pthread_rwlock_unlock(&lock)
        } catch {
            pthread_rwlock_unlock(&lock)
            throw error
        }
    }

    func enumerated() -> EnumeratedSequence<[Key: Value]> {
        pthread_rwlock_rdlock(&lock)
        let rst = dic.enumerated()
        pthread_rwlock_unlock(&lock)
        return rst
    }

    func contains(where predicate: ((key: Key, value: Value)) throws -> Bool) rethrows -> Bool {
        pthread_rwlock_rdlock(&lock)
        do {
            let rst = try dic.contains(where: predicate)
            pthread_rwlock_unlock(&lock)
            return rst
        } catch {
            pthread_rwlock_unlock(&lock)
            throw error
        }
    }

    func reduce<Result>(_ initialResult: Result, _ nextPartialResult: (Result, (key: Key, value: Value)) throws -> Result) rethrows -> Result {
        pthread_rwlock_rdlock(&lock)
        do {
            let rst = try dic.reduce(initialResult, nextPartialResult)
            pthread_rwlock_unlock(&lock)
            return rst
        } catch {
            pthread_rwlock_unlock(&lock)
            throw error
        }
    }

    func reversed() -> [(key: Key, value: Value)] {
        pthread_rwlock_rdlock(&lock)
        let rst = dic.reversed()
        pthread_rwlock_unlock(&lock)
        return rst
    }

    func flatMap<SegmentOfResult>(_ transform: ((key: Key, value: Value)) throws -> SegmentOfResult) rethrows -> [SegmentOfResult.Element] where SegmentOfResult: Sequence {
        pthread_rwlock_rdlock(&lock)
        do {
            let rst = try dic.flatMap(transform)
            pthread_rwlock_unlock(&lock)
            return rst
        } catch {
            pthread_rwlock_unlock(&lock)
            throw error
        }
    }

    func compactMap<ElementOfResult>(_ transform: ((key: Key, value: Value)) throws -> ElementOfResult?) rethrows -> [ElementOfResult] {
        pthread_rwlock_rdlock(&lock)
        do {
            let rst = try dic.compactMap(transform)
            pthread_rwlock_unlock(&lock)
            return rst
        } catch {
            pthread_rwlock_unlock(&lock)
            throw error
        }
    }

    func sorted(by areInIncreasingOrder: ((key: Key, value: Value), (key: Key, value: Value)) throws -> Bool) rethrows -> [(key: Key, value: Value)] {
        pthread_rwlock_rdlock(&lock)
        do {
            let rst = try dic.sorted(by: areInIncreasingOrder)
            pthread_rwlock_unlock(&lock)
            return rst
        } catch {
            pthread_rwlock_unlock(&lock)
            throw error
        }
    }
}

extension ThreadSafeDictionary {
    var isEmpty: Bool {
        pthread_rwlock_rdlock(&lock)
        let rst = dic.isEmpty
        pthread_rwlock_unlock(&lock)
        return rst
    }

    var first: (key: Key, value: Value)? {
        pthread_rwlock_rdlock(&lock)
        let rst = dic.first
        pthread_rwlock_unlock(&lock)
        return rst
    }

    var underestimatedCount: Int {
        pthread_rwlock_rdlock(&lock)
        let rst = dic.underestimatedCount
        pthread_rwlock_unlock(&lock)
        return rst
    }

    var count: Int {
        pthread_rwlock_rdlock(&lock)
        let rst = dic.count
        pthread_rwlock_unlock(&lock)
        return rst
    }
}
