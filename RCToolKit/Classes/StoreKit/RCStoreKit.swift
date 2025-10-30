//
//  RCStoreKit.swift
//  Alamofire
//
//  Created by yoyo on 2024/10/15.
//

import Foundation
import StoreKit

open class RCStoreKit {
    
    public class var canMakePayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    private let productsProvider: RCStoreProductsnfoDataProvider = .init()
    private let paymentQueueProvider: RCPaymentQueueDataProvider = .init()
    
    
    fileprivate static let `default` = RCStoreKit()
    
    public func registerDelegate(_ delegate:PaymentTransactionStateDelegate?) {
        paymentQueueProvider.delegate = delegate
    }
    
    public class func registerDelegate(_ delegate:PaymentTransactionStateDelegate?) {
        RCStoreKit.default.registerDelegate(delegate)
    }
    
}

public extension RCStoreKit {
    private func getProductInfo(_ productIds: Set<String>, completion: @escaping (RetrieveResults) -> Void) -> RCInAppProductRequest {
        productsProvider.getProductsInfo(productIds, completion: completion)
    }

    private func purchaseProduct(_ productId: String, quantity: Int = 1, atomically: Bool = true, applicationUsername: String = "", simulatesAskToBuyInSandbox: Bool = false, completion: @escaping (PurchaseResult) -> Void) -> RCInAppProductRequest {
        getProductInfo(Set([productId])) { result in
            if let error = result.error {
                completion(.error(error: SKError(_nsError: error as NSError)))
                return
            }
            if let invalidProductId = result.invalidProductIDs.first {
                let userInfo = [NSLocalizedDescriptionKey: "Invalid product id: \(invalidProductId)"]
                let error = NSError(domain: SKErrorDomain, code: SKError.paymentInvalid.rawValue, userInfo: userInfo)
                completion(.error(error: SKError(_nsError: error)))
                return
            }

            let products = result.retrievedProducts.first { e in
                e.productIdentifier == productId
            }
            guard let p = products else {
                let userInfo = [NSLocalizedDescriptionKey: "not found product id: \(productId)"]
                let error = NSError(domain: SKErrorDomain, code: SKError.paymentInvalid.rawValue, userInfo: userInfo)
                completion(.error(error: SKError(_nsError: error)))
                return
            }
            self.purchase(product: p, quantity: quantity, atomically: atomically, applicationUsername: applicationUsername, simulatesAskToBuyInSandbox: simulatesAskToBuyInSandbox, completion: completion)
        }
    }

    private func purchase(product: SKProduct, quantity: Int, atomically: Bool, applicationUsername: String = "", simulatesAskToBuyInSandbox: Bool = false, paymentDiscount: PaymentDiscount? = nil, completion: @escaping (PurchaseResult) -> Void) {
        paymentQueueProvider.startPayment(Payment(product: product, paymentDiscount: paymentDiscount, quantity: quantity, atomically: atomically, applicationUsername: applicationUsername, simulatesAskToBuyInSandbox: simulatesAskToBuyInSandbox) { resuts in
            completion(self.processPurchaseResult(resuts))
        })
    }
    
    fileprivate func restorePurchases(atomically: Bool = true, applicationUsername: String = "", completion: @escaping (RestoreResults) -> Void) {
        
        paymentQueueProvider.restorePurchases(RestorePurchases(atomically: atomically, applicationUsername: applicationUsername) { results in
            let results = self.processRestoreResults(results)
            completion(results)
        })
    }

    private func processPurchaseResult(_ result: TransactionResult) -> PurchaseResult {
        switch result {
        case .purchased(let purchase):
            return .success(purchase: purchase)
        case .deferred(let purchase):
            return .deferred(purchase: purchase)
        case .failed(let error):
            return .error(error: error)
        case .restored(let purchase):
            return .error(error: storeInternalError(description: "Cannot restore product \(purchase.productId) from purchase path"))
        }
    }

    private func processRestoreResults(_ results: [TransactionResult]) -> RestoreResults {
        var restoredPurchases: [Purchase] = []
        var restoreFailedPurchases: [(SKError, String?)] = []
        for result in results {
            switch result {
            case .purchased(let purchase):
                let error = storeInternalError(description: "Cannot purchase product \(purchase.productId) from restore purchases path")
                restoreFailedPurchases.append((error, purchase.productId))
            case .deferred(let purchase):
                let error = storeInternalError(description: "Cannot purchase product \(purchase.productId) from restore purchases path")
                restoreFailedPurchases.append((error, purchase.productId))
            case .failed(let error):
                restoreFailedPurchases.append((error, nil))
            case .restored(let purchase):
                restoredPurchases.append(purchase)
            }
        }
        return RestoreResults(restoredPurchases: restoredPurchases, restoreFailedPurchases: restoreFailedPurchases)
    }

    private func storeInternalError(code: SKError.Code = SKError.unknown, description: String = "") -> SKError {
        let error = NSError(domain: SKErrorDomain, code: code.rawValue, userInfo: [NSLocalizedDescriptionKey: description])
        return SKError(_nsError: error)
    }
}

public extension RCStoreKit {
    @discardableResult
    class func getProductInfo(_ productIds: Set<String>, completion: @escaping (RetrieveResults) -> Void) -> RCInAppProductRequest {
        self.default.getProductInfo(productIds, completion: completion)
    }

    @discardableResult
    class func purchaseProduct(_ productId: String, quantity: Int = 1, atomically: Bool = true, applicationUsername: String = "", simulatesAskToBuyInSandbox: Bool = false, completion: @escaping (PurchaseResult) -> Void) -> RCInAppProductRequest {
        self.default.purchaseProduct(productId, quantity: quantity, atomically: atomically, applicationUsername: applicationUsername, simulatesAskToBuyInSandbox: simulatesAskToBuyInSandbox, completion: completion)
    }

    class func purchaseProduct(_ product: SKProduct, quantity: Int = 1, atomically: Bool = true, applicationUsername: String = "", simulatesAskToBuyInSandbox: Bool = false, paymentDiscount: PaymentDiscount? = nil, completion: @escaping (PurchaseResult) -> Void) {
        self.default.purchase(product: product, quantity: quantity, atomically: atomically, applicationUsername: applicationUsername, simulatesAskToBuyInSandbox: simulatesAskToBuyInSandbox, paymentDiscount: paymentDiscount, completion: completion)
    }
    
    class func restorePurchases(atomically: Bool = true, applicationUsername: String = "", completion: @escaping (RestoreResults) -> Void) {
        
        self.default.restorePurchases(atomically: atomically, applicationUsername: applicationUsername, completion: completion)
    }
    
}
