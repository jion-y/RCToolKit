//
//  Queue.swift
//  Pods
//
//  Created by yoyo on 2022/9/7.
//

import Foundation
public class RCQueue<T> {
    private let array:ThreadSafeArray = ThreadSafeArray<T>();
    
    public var queueSize:Int {
        return array.count;
    }
    
    public func enQueue(e:T)->Int {
        array.append(e)
        return 0
    }
    public func deQueue() ->T? {
        if array.isEmpty { return nil }
        let e = array.first;
        array.remove(at: 0);
        return e!
    }
    
    private func isFull() ->Bool {
        return false
        
    }
    private func isEmpty()->Bool {
        return (queueSize == 0 )
    }
}
