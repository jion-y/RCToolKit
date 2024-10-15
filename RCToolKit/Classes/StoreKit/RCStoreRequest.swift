//
//  RCStoreRequest.swift
//  Alamofire
//
//  Created by yoyo on 2024/10/15.
//

import Foundation
import StoreKit

public struct RetrieveResults {
    public let retrievedProducts: Set<SKProduct>
    public let invalidProductIDs: Set<String>
    public let error: Error?

    public init(retrievedProducts: Set<SKProduct>, invalidProductIDs: Set<String>, error: Error?) {
        self.retrievedProducts = retrievedProducts
        self.invalidProductIDs = invalidProductIDs
        self.error = error
    }
}

typealias RCProductRequestCallback = (RetrieveResults) -> Void

public protocol RCStoreRequestEnable {
    func start()
    func canncel()
}

public protocol RCInAppProductRequest: RCStoreRequestEnable {
    var hasCompleted: Bool { get }
    var cachedResults: RetrieveResults? { get }
}

open class RCAppStoreRequest: NSObject {
    private let callback: RCProductRequestCallback
    private let request: SKProductsRequest
    private var innerResult: RetrieveResults?

    init(productIds: Set<String>, callback: @escaping RCProductRequestCallback) {
        self.callback = callback
        self.request = SKProductsRequest(productIdentifiers: productIds)
        super.init()
        request.delegate = self
    }

    deinit {
        self.request.delegate = nil
    }
}

extension RCAppStoreRequest: RCInAppProductRequest {
    public var cachedResults: RetrieveResults? {
        innerResult
    }

    public var hasCompleted: Bool {
        innerResult != nil
    }

    public func start() {
        request.start()
    }

    public func canncel() {
        if !hasCompleted {
            request.cancel()
        }
    }
}

extension RCAppStoreRequest: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let retrievedProducts = Set<SKProduct>(response.products)
        let invalidProductIDs = Set<String>(response.invalidProductIdentifiers)
        let results = RetrieveResults(
            retrievedProducts: retrievedProducts,
            invalidProductIDs: invalidProductIDs, error: nil
        )
        innerResult = results
        performCallback(results)
    }

    public func request(_ request: SKRequest, didFailWithError error: Error) {
        let result = RetrieveResults(retrievedProducts: Set<SKProduct>(), invalidProductIDs: Set<String>(), error: error)
        innerResult = result
        performCallback(result)
    }

    public func requestDidFinish(_ request: SKRequest) {}
}

extension RCAppStoreRequest {
    private func performCallback(_ results: RetrieveResults) {
        DispatchQueue.main.async {
            self.callback(results)
        }
    }
}
