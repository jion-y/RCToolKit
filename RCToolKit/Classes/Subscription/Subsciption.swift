//
//  Subsciption.swift
//  Pods-RCToolKit_Example
//
//  Created by yoyo on 2022/9/9.
//

import Foundation
/// 简单实现订阅模式

public protocol Subcribable: NSObject {
    func onValueChange(newValue: [String: Any])
    func subscribe(_ publisher: Publishable)
    func cancelSubscribe(_ publisher: Publishable)
}

public extension Subcribable {
    func subscribe(_ publisher: Publishable) { publisher.addReciver(reciver: WeakProxySubscriber(self)) }
    func cancelSubscribe(_ publisher: Publishable) { publisher.removeReciver(reciver: WeakProxySubscriber(self)) }
}

public protocol Publishable {
    func addReciver(reciver: WeakProxySubscriber)
    func removeReciver(reciver: WeakProxySubscriber)
    func Publish(_ value: [String: Any])
}

public class WeakProxySubscriber: NSObject {
    static func == (lhs: WeakProxySubscriber, rhs: WeakProxySubscriber) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    private weak var target: Subcribable?
    private let identifier = UUID().uuidString
    init(_ tagert: Subcribable) {
        self.target = tagert
    }

    public func validateTarget() -> Bool {
        return self.target != nil
    }
}

extension WeakProxySubscriber: Subcribable {
    public func onValueChange(newValue: [String: Any]) {
        guard let t = target else {
            return
        }
        t.onValueChange(newValue: newValue)
    }
}

public class DefaultRCPublisher {
    private let subscribers: ThreadSafeArray<WeakProxySubscriber> = ThreadSafeArray()
    private func removeProxyWhenTargetNil() {
        var willDeletaArray: [WeakProxySubscriber] = []
        self.subscribers.forEach { s in
            if !s.validateTarget() { willDeletaArray.append(s) }
        }
        willDeletaArray.forEach { s in
            self.subscribers.remove { $0 == s }
        }
    }
}

extension DefaultRCPublisher: Publishable {
    public func addReciver(reciver: WeakProxySubscriber) {
        if !self.subscribers.contains(reciver) {
            self.subscribers.append(reciver)
        }
    }

    public func removeReciver(reciver: WeakProxySubscriber) {
        self.subscribers.remove { $0 == reciver
        }
    }

    public func Publish(_ value: [String: Any]) {
        self.removeProxyWhenTargetNil()
        self.subscribers.forEach { $0.onValueChange(newValue: value)
        }
    }
}
