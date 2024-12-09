//
//  DispatchQueue+Extension.swift
//  Alamofire
//
//  Created by yoyo on 2024/9/25.
//

import Foundation

public extension ExtensionWrapper where Base == DispatchQueue.Type {
    func safeRunMainQueue(execute work:@escaping @convention(block) () -> Void ){
        if  Thread.isMainThread {
            work()
        } else {
            base.main.async {
                work()
            }
        }
    }
    func currentOrAsync(_ block: @MainActor @Sendable @escaping () -> Void) {
        if Thread.isMainThread {
            MainActor.runUnsafely { block() }
        } else {
            DispatchQueue.main.async { block() }
        }
    }
}
extension MainActor {
    @_unavailableFromAsync
    static func runUnsafely<T: Sendable>(_ body: @MainActor () throws -> T) rethrows -> T {
#if swift(>=5.10)
        return try MainActor.assumeIsolated(body)
#else
        dispatchPrecondition(condition: .onQueue(.main))
        return try withoutActuallyEscaping(body) { fn in
            try unsafeBitCast(fn, to: (() throws -> T).self)()
        }
#endif
    }
}
