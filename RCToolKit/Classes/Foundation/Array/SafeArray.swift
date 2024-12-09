//
//  SafeArray.swift
//  PTCommonPlugins
//
//  Created by liuming on 2021/11/22.
//

import Foundation

// MARK: - ThreadSafeArray

public class ThreadSafeArray<Element> {
    private var array: [Element] = []
    private var lock = pthread_rwlock_t()

    public init() {
        let status = pthread_rwlock_init(&lock, nil)
        assert(status == 0)
    }

    public convenience init(array: [Element]) {
        self.init()
        self.array = array
    }
    deinit {
        pthread_rwlock_destroy(&lock)
    }
}

// MARK: - Properties

public extension ThreadSafeArray {
    var first: Element? {
        var result: Element?
        pthread_rwlock_rdlock(&lock)
        result = array.first
        pthread_rwlock_unlock(&lock)
        return result
    }

    var last: Element? {
        var result: Element?
        pthread_rwlock_rdlock(&lock)
        result = array.last
        pthread_rwlock_unlock(&lock)
        return result
    }

    var count: Int {
        pthread_rwlock_rdlock(&lock)
        let count = array.count
        pthread_rwlock_unlock(&lock)
        return count
    }

    var isEmpty: Bool {
        pthread_rwlock_rdlock(&lock)
        let result = (array.count > 0)
        pthread_rwlock_unlock(&lock)
        return result
    }

    var description: String {
        pthread_rwlock_rdlock(&lock)
        let str = array.description
        pthread_rwlock_unlock(&lock)
        return str
    }
}

// MARK: - Immutable

public extension ThreadSafeArray {
    func first(where predicate: (Element)->Bool)->Element? {
        pthread_rwlock_rdlock(&lock)
        let result = array.first(where: predicate)
        pthread_rwlock_unlock(&lock)
        return result
    }

    func last(where predicate: (Element)->Bool)->Element? {
        pthread_rwlock_rdlock(&lock)
        let result = array.last(where: predicate)
        pthread_rwlock_unlock(&lock)
        return result
    }

    func filter(isIncluded: @escaping (Element)->Bool) ->ThreadSafeArray<Element> {
        pthread_rwlock_rdlock(&lock)
        let result = array.filter(isIncluded)
        pthread_rwlock_unlock(&lock)
        return ThreadSafeArray(array: result)
    }

    func index(where predicate: (Element)->Bool)-> Int? {
        pthread_rwlock_rdlock(&lock)
        let result = array.firstIndex(where: predicate)
        pthread_rwlock_unlock(&lock)
        return result
    }

    func sorted(by areInIncreasingOrder: (Element, Element)->Bool)->ThreadSafeArray<Element> {
        pthread_rwlock_rdlock(&lock)
        let result = array.sorted(by: areInIncreasingOrder)
        let newArray = ThreadSafeArray<Element>(array: result)
        pthread_rwlock_unlock(&lock)
        return newArray
    }

    func map<T>(_ transform: @escaping (Element)->T) ->[T] {
        pthread_rwlock_rdlock(&lock)
        let result = array.map(transform)
        pthread_rwlock_unlock(&lock)
        return result
    }

    func compactMap<T>(_ transform: (Element)->T)->[T] {
        pthread_rwlock_rdlock(&lock)
        let result = array.compactMap(transform)
        pthread_rwlock_unlock(&lock)
        return result
    }

    func reduce<T>(initialResult: T, _ nexPartialResult: @escaping (T, Element)->T)->T {
        pthread_rwlock_rdlock(&lock)
        let result = array.reduce(initialResult, nexPartialResult)
        pthread_rwlock_unlock(&lock)
        return result
    }

    func forEach(_ body: (Element)->Void) {
        pthread_rwlock_rdlock(&lock)
        array.forEach(body)
        pthread_rwlock_unlock(&lock)
    }

    func contains(where predicate: (Element)->Bool)->Bool {
        pthread_rwlock_rdlock(&lock)
        let result = array.contains(where: predicate)
        pthread_rwlock_unlock(&lock)
        return result
    }
    
//    public func contains(_ element: Element) -> Bool {
//        pthread_rwlock_rdlock(&lock)
//        let result = array.contains {  $0 == element }
//        pthread_rwlock_unlock(&lock)
//        return result
//    }
    func allSatisfy(_ predicate: (Element)->Bool)->Bool {
        pthread_rwlock_rdlock(&lock)
        let result = array.allSatisfy(predicate)
        pthread_rwlock_unlock(&lock)
        return result
    }
}

// MARK: - Mutable

public extension ThreadSafeArray {
    func append(_ element: Element) {
        pthread_rwlock_wrlock(&lock)
        array.append(element)
        pthread_rwlock_unlock(&lock)
    }

    func append(_ elements: [Element]) {
        pthread_rwlock_wrlock(&lock)
        array += elements
        pthread_rwlock_unlock(&lock)
    }

    func insert(_ element: Element, at index: Int) {
        pthread_rwlock_wrlock(&lock)
        array.insert(element, at: index)
        pthread_rwlock_unlock(&lock)
    }

    func remove(at index: Int, completion: ((Element)->Void)? = nil) {
        pthread_rwlock_wrlock(&lock)
        if index >= 0, index < count {
            let e = array.remove(at: index)
            completion?(e)
        }
        pthread_rwlock_unlock(&lock)
    }

    func remove(where predicate: @escaping (Element)->Bool, completion: (([Element])->Void)? = nil) {
        pthread_rwlock_wrlock(&lock)
        var elements = [Element]()
        while let index = array.firstIndex(where: predicate) {
            elements.append(array.remove(at: index))
        }
        completion?(elements)
        pthread_rwlock_unlock(&lock)
    }

    func removeAll(completion: (([Element])->Void)? = nil) {
        pthread_rwlock_wrlock(&lock)
        let elements = array
        array.removeAll()
        completion?(elements)
        pthread_rwlock_unlock(&lock)
    }
}

public extension ThreadSafeArray {
    subscript(index: Int)->Element? {
        get {
            pthread_rwlock_rdlock(&lock)
            var result: Element?
            guard self.array.startIndex..<self.array.endIndex ~= index else {
                pthread_rwlock_unlock(&lock)
                return nil
            }
            
            result = self.array[index]
            pthread_rwlock_unlock(&lock)
            return result
        }
        set {
            
            guard let newValue = newValue else {
                return
            }
            if index < self.count {
                pthread_rwlock_wrlock(&lock)
                self.array[index] = newValue
                pthread_rwlock_unlock(&lock)
            }
        }
    }
}

// MARK: - Equatable

public extension ThreadSafeArray where Element: Equatable {
    func contains(_ element: Element)->Bool {
        pthread_rwlock_rdlock(&lock)
        let result = self.array.contains(element)
        pthread_rwlock_unlock(&lock)
        return result
    }
}

// MARK: - Infix operators

public extension ThreadSafeArray {
    /// Adds a new element at the end of the array.
    ///
    /// - Parameters:
    ///   - left: The collection to append to.
    ///   - right: The element to append to the array.
    static func +=(left: inout ThreadSafeArray, right: Element) {
        left.append(right)
    }

    /// Adds new elements at the end of the array.
    ///
    /// - Parameters:
    ///   - left: The collection to append to.
    ///   - right: The elements to append to the array.
    static func +=(left: inout ThreadSafeArray, right: [Element]) {
        left.append(right)
    }
}
