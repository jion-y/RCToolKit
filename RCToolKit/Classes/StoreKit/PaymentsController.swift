//
//  PaymentsController.swift
//  Alamofire
//
//  Created by yoyo on 2024/10/15.
//

import Foundation
import StoreKit

struct Payment: Hashable {
    let product: SKProduct

    let paymentDiscount: PaymentDiscount?
    let quantity: Int
    let atomically: Bool
    let applicationUsername: String
    let simulatesAskToBuyInSandbox: Bool
    let callback: (TransactionResult) -> Void

    func hash(into hasher: inout Hasher) {
        hasher.combine(product)
        hasher.combine(quantity)
        hasher.combine(atomically)
        hasher.combine(applicationUsername)
        hasher.combine(simulatesAskToBuyInSandbox)
    }

    static func == (lhs: Payment, rhs: Payment) -> Bool {
        lhs.product.productIdentifier == rhs.product.productIdentifier
    }
}

public struct PaymentDiscount {
    let discount: AnyObject?

    @available(iOS 12.2, tvOS 12.2, OSX 10.14.4, watchOS 6.2, macCatalyst 13.0, *)
    public init(discount: SKPaymentDiscount) {
        self.discount = discount
    }

    private init() {
        self.discount = nil
    }
}

class PaymentsController: TransactionController {
    private var payments: [Payment] = []

    private func findPaymentIndex(withProductIdentifier identifier: String) -> Int? {
        for payment in payments where payment.product.productIdentifier == identifier {
            return payments.firstIndex(of: payment)
        }
        return nil
    }

    func hasPayment(_ payment: Payment) -> Bool {
        findPaymentIndex(withProductIdentifier: payment.product.productIdentifier) != nil
    }

    func append(_ payment: Payment) {
        payments.append(payment)
    }

    func processTransaction(_ transaction: SKPaymentTransaction, on paymentQueue: SKPaymentQueue) -> Bool {
        let transactionProductIdentifier = transaction.payment.productIdentifier

        guard let paymentIndex = findPaymentIndex(withProductIdentifier: transactionProductIdentifier) else {
            return false
        }
        let payment = payments[paymentIndex]

        let transactionState = transaction.transactionState

        if transactionState == .purchased {
            let purchase = PurchaseDetails(productId: transactionProductIdentifier, quantity: transaction.payment.quantity, product: payment.product, transaction: transaction, originalTransaction: transaction.original, needsFinishTransaction: !payment.atomically)

            payment.callback(.purchased(purchase: purchase))

            if payment.atomically {
                paymentQueue.finishTransaction(transaction)
            }
            payments.remove(at: paymentIndex)
            return true
        }

        if transactionState == .restored {
            print("Unexpected restored transaction for payment \(transactionProductIdentifier)")

            let purchase = PurchaseDetails(productId: transactionProductIdentifier, quantity: transaction.payment.quantity, product: payment.product, transaction: transaction, originalTransaction: transaction.original, needsFinishTransaction: !payment.atomically)

            payment.callback(.purchased(purchase: purchase))

            if payment.atomically {
                paymentQueue.finishTransaction(transaction)
            }
            payments.remove(at: paymentIndex)
            return true
        }

        if transactionState == .failed {
            payment.callback(.failed(error: transactionError(for: transaction.error as NSError?)))

            paymentQueue.finishTransaction(transaction)
            payments.remove(at: paymentIndex)
            return true
        }

        if transactionState == .deferred {
            let purchase = PurchaseDetails(productId: transactionProductIdentifier, quantity: transaction.payment.quantity, product: payment.product, transaction: transaction, originalTransaction: transaction.original, needsFinishTransaction: !payment.atomically)

            payment.callback(.deferred(purchase: purchase))

            payments.remove(at: paymentIndex)
            return true
        }

        return false
    }

    func transactionError(for error: NSError?) -> SKError {
        let message = "Unknown error"
        let altError = NSError(domain: SKErrorDomain, code: SKError.unknown.rawValue, userInfo: [NSLocalizedDescriptionKey: message])
        let nsError = error ?? altError
        return SKError(_nsError: nsError)
    }

    func processTransactions(_ transactions: [SKPaymentTransaction], on paymentQueue: SKPaymentQueue) -> [SKPaymentTransaction] {
        transactions.filter { !processTransaction($0, on: paymentQueue) }
    }
}
