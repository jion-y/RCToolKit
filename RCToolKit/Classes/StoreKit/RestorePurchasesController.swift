//
//  RestorePurchasesController.swift
//  Alamofire
//
//  Created by yoyo on 2024/10/15.
//

import Foundation
import StoreKit

struct RestorePurchases {
    let atomically: Bool
    let applicationUsername: String?
    let callback: ([TransactionResult]) -> Void

    init(atomically: Bool, applicationUsername: String? = nil, callback: @escaping ([TransactionResult]) -> Void) {
        self.atomically = atomically
        self.applicationUsername = applicationUsername
        self.callback = callback
    }
}

class RestorePurchasesController: TransactionController {

    public var restorePurchases: RestorePurchases?

    private var restoredPurchases: [TransactionResult] = []

    func processTransaction(_ transaction: SKPaymentTransaction, atomically: Bool, on paymentQueue: SKPaymentQueue) -> Purchase? {

        let transactionState = transaction.transactionState

        if transactionState == .restored {

            let transactionProductIdentifier = transaction.payment.productIdentifier
            
            let purchase = Purchase(productId: transactionProductIdentifier, quantity: transaction.payment.quantity, transaction: transaction, originalTransaction: transaction.original, needsFinishTransaction: !atomically)
            if atomically {
                paymentQueue.finishTransaction(transaction)
            }
            return purchase
        }
        return nil
    }

    func processTransactions(_ transactions: [SKPaymentTransaction], on paymentQueue: SKPaymentQueue) -> [SKPaymentTransaction] {

        guard let restorePurchases = restorePurchases else {
            return transactions
        }

        var unhandledTransactions: [SKPaymentTransaction] = []
        for transaction in transactions {
            if let restoredPurchase = processTransaction(transaction, atomically: restorePurchases.atomically, on: paymentQueue) {
                restoredPurchases.append(.restored(purchase: restoredPurchase))
            } else {
                unhandledTransactions.append(transaction)
            }
        }

        return unhandledTransactions
    }

    func restoreCompletedTransactionsFailed(withError error: Error) {

        guard let restorePurchases = restorePurchases else {
            print("Callback already called. Returning")
            return
        }
        restoredPurchases.append(.failed(error: SKError(_nsError: error as NSError)))
        restorePurchases.callback(restoredPurchases)

        // Reset state after error received
        restoredPurchases = []
        self.restorePurchases = nil

    }

    func restoreCompletedTransactionsFinished() {

        guard let restorePurchases = restorePurchases else {
            print("Callback already called. Returning")
            return
        }
        restorePurchases.callback(restoredPurchases)

        // Reset state after error transactions finished
        restoredPurchases = []
        self.restorePurchases = nil
    }
}
