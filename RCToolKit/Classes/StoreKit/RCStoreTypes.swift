//
//  RCStoreTypes.swift
//  Alamofire
//
//  Created by yoyo on 2024/10/15.
//

import Foundation
import StoreKit

/// Payment transaction
public protocol PaymentTransaction {
    var transactionDate: Date? { get }
    var transactionState: SKPaymentTransactionState { get }
    var transactionIdentifier: String? { get }
    var downloads: [SKDownload] { get }
}

/// Purchased product
public struct PurchaseDetails {
    public let productId: String
    public let quantity: Int
    public let product: SKProduct
    public let transaction: SKPaymentTransaction
    public let originalTransaction: SKPaymentTransaction?
    public let needsFinishTransaction: Bool
    
    public init(productId: String, quantity: Int, product: SKProduct, transaction: SKPaymentTransaction, originalTransaction: SKPaymentTransaction?, needsFinishTransaction: Bool) {
        self.productId = productId
        self.quantity = quantity
        self.product = product
        self.transaction = transaction
        self.originalTransaction = originalTransaction
        self.needsFinishTransaction = needsFinishTransaction
    }
}


/// Purchase result
public enum PurchaseResult {
    case success(purchase: PurchaseDetails)
    case deferred(purchase: PurchaseDetails)
    case error(error: SKError)
}

// Restored product
public struct Purchase {
    public let productId: String
    public let quantity: Int
    public let transaction: SKPaymentTransaction
    public let originalTransaction: SKPaymentTransaction?
    public let needsFinishTransaction: Bool
    
    public init(productId: String, quantity: Int, transaction: SKPaymentTransaction, originalTransaction: SKPaymentTransaction?, needsFinishTransaction: Bool) {
        self.productId = productId
        self.quantity = quantity
        self.transaction = transaction
        self.originalTransaction = originalTransaction
        self.needsFinishTransaction = needsFinishTransaction
    }
}


public struct RestoreResults {
    public let restoredPurchases: [Purchase]
    public let restoreFailedPurchases: [(SKError, String?)]
    
    public init(restoredPurchases: [Purchase], restoreFailedPurchases: [(SKError, String?)]) {
        self.restoredPurchases = restoredPurchases
        self.restoreFailedPurchases = restoreFailedPurchases
    }
}
