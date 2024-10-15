//
//  RCPaymentQueueDataProvider.swift
//  Alamofire
//
//  Created by yoyo on 2024/10/15.
//

import Foundation
import StoreKit

protocol TransactionController {
    /// Process the supplied transactions on a given queue.
    /// - parameter transactions: transactions to process
    /// - parameter paymentQueue: payment queue for finishing transactions
    /// - returns: array of unhandled transactions
    func processTransactions(_ transactions: [SKPaymentTransaction], on paymentQueue: SKPaymentQueue) -> [SKPaymentTransaction]
}

public enum TransactionResult {
    case purchased(purchase: PurchaseDetails)
    case restored(purchase: Purchase)
    case deferred(purchase: PurchaseDetails)
    case failed(error: SKError)
}

extension SKPaymentTransactionState: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .purchasing: return "purchasing"
        case .purchased: return "purchased"
        case .failed: return "failed"
        case .restored: return "restored"
        case .deferred: return "deferred"
        @unknown default: return "default"
        }
    }
}

open class RCPaymentQueueDataProvider: NSObject {
    private let paymentsController: PaymentsController
    private let restorePurchasesController: RestorePurchasesController = RestorePurchasesController()
    private let completeTransactionsController: CompleteTransactionsController = CompleteTransactionsController()
    let paymentQueue: SKPaymentQueue
//    private var entitlementRevocation: EntitlementRevocation?
    init(paymentQueue: SKPaymentQueue = SKPaymentQueue.default(), paymentsController: PaymentsController = PaymentsController()) {
        self.paymentQueue = paymentQueue
        self.paymentsController = paymentsController
    }
    
    func startPayment(_ payment: Payment) {
//        assertCompleteTransactionsWasCalled()
        
        let skPayment = SKMutablePayment(product: payment.product)
        skPayment.applicationUsername = payment.applicationUsername
        skPayment.quantity = payment.quantity
        
        if #available(iOS 12.2, tvOS 12.2, OSX 10.14.4, watchOS 6.2, *) {
            if let discount = payment.paymentDiscount?.discount as? SKPaymentDiscount {
                skPayment.paymentDiscount = discount
            }
        }
        
        paymentQueue.add(skPayment)
        paymentsController.append(payment)
    }
    
    func restorePurchases(_ restorePurchases: RestorePurchases) {
//        assertCompleteTransactionsWasCalled()
        
        if restorePurchasesController.restorePurchases != nil {
            return
        }
        
        paymentQueue.restoreCompletedTransactions(withApplicationUsername: restorePurchases.applicationUsername)
        
        restorePurchasesController.restorePurchases = restorePurchases
    }
    
    func completeTransactions(_ completeTransactions: CompleteTransactions) {
        guard completeTransactionsController.completeTransactions == nil else {
            print("SwiftyStoreKit.completeTransactions() should only be called once when the app launches. Ignoring this call")
            return
        }
        
        completeTransactionsController.completeTransactions = completeTransactions
    }
}

extension RCPaymentQueueDataProvider: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        var unhandledTransactions = transactions.filter { $0.transactionState != .purchasing }
        
        if unhandledTransactions.count > 0 {
            unhandledTransactions = paymentsController.processTransactions(transactions, on: paymentQueue)
            
            unhandledTransactions = restorePurchasesController.processTransactions(unhandledTransactions, on: paymentQueue)
            
            unhandledTransactions = completeTransactionsController.processTransactions(unhandledTransactions, on: paymentQueue)
            
            if unhandledTransactions.count > 0 {
                let strings = unhandledTransactions.map(\.debugDescription).joined(separator: "\n")
                print("unhandledTransactions:\n\(strings)")
            }
        }
    }
}
