//
//  CompleteTransactionsController.swift
//  Alamofire
//
//  Created by yoyo on 2024/10/15.
//

import Foundation
import StoreKit

struct CompleteTransactions {
    let atomically: Bool
    let callback: ([Purchase]) -> Void

    init(atomically: Bool, callback: @escaping ([Purchase]) -> Void) {
        self.atomically = atomically
        self.callback = callback
    }
}

class CompleteTransactionsController: TransactionController {

    var completeTransactions: CompleteTransactions?

    func processTransactions(_ transactions: [SKPaymentTransaction], on paymentQueue: SKPaymentQueue) -> [SKPaymentTransaction] {

        guard let completeTransactions = completeTransactions else {
            print("SwiftyStoreKit.completeTransactions() should be called once when the app launches.")
            return transactions
        }

        var unhandledTransactions: [SKPaymentTransaction] = []
        var purchases: [Purchase] = []

        for transaction in transactions {

            let transactionState = transaction.transactionState

            if transactionState != .purchasing {

                let willFinishTransaction = completeTransactions.atomically || transactionState == .failed
                let purchase = Purchase(productId: transaction.payment.productIdentifier, quantity: transaction.payment.quantity, transaction: transaction, originalTransaction: transaction.original, needsFinishTransaction: !willFinishTransaction)

                purchases.append(purchase)

                if willFinishTransaction {
                    print("Finishing transaction for payment \"\(transaction.payment.productIdentifier)\" with state: \(transactionState.debugDescription)")
                    paymentQueue.finishTransaction(transaction)
                }
            } else {
                unhandledTransactions.append(transaction)
            }
        }
        if purchases.count > 0 {
            completeTransactions.callback(purchases)
        }

        return unhandledTransactions
    }
}
