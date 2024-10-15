//
//  RCStoreKit2.swift
//  Alamofire
//
//  Created by yoyo on 2024/10/15.
//

import Foundation
import StoreKit

@available(iOS 13, *)
// 协程封装下，方便上传使用
public class RCStoreKit2 {
    class func getProductInfo(_ productIds: Set<String>, completion: @escaping (RetrieveResults) -> Void) async -> RetrieveResults {
        await withCheckedContinuation { continuation in
            let _ = RCStoreKit.getProductInfo(productIds) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    class func purchaseProduct(_ productId: String, quantity: Int = 1, atomically: Bool = true, applicationUsername: String = "", simulatesAskToBuyInSandbox: Bool = false, completion: @escaping (PurchaseResult) -> Void) async -> PurchaseResult {
        await withCheckedContinuation { continuation in
            RCStoreKit.purchaseProduct(productId, quantity: quantity, atomically: atomically, applicationUsername: applicationUsername, simulatesAskToBuyInSandbox: simulatesAskToBuyInSandbox) { result in
                continuation.resume(returning: result)
            }
        }
    }

    class func purchaseProduct(_ product: SKProduct, quantity: Int = 1, atomically: Bool = true, applicationUsername: String = "", simulatesAskToBuyInSandbox: Bool = false, paymentDiscount: PaymentDiscount? = nil, completion: @escaping (PurchaseResult) -> Void) async -> PurchaseResult {
        await withCheckedContinuation { continuation in
            RCStoreKit.purchaseProduct(product, quantity: quantity, atomically: atomically, applicationUsername: applicationUsername, simulatesAskToBuyInSandbox: simulatesAskToBuyInSandbox) { result in
                continuation.resume(returning: result)
            }
        }
    }

    class func restorePurchases(atomically: Bool = true, applicationUsername: String = "", completion: @escaping (RestoreResults) -> Void) async -> RestoreResults {
        await withCheckedContinuation { continuation in
            RCStoreKit.restorePurchases(atomically: atomically, applicationUsername: applicationUsername) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
