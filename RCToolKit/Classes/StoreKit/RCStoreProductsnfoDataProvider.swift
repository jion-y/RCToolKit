//
//  RCStoreIProductsnfoDataProvider.swift
//  Alamofire
//
//  Created by yoyo on 2024/10/15.
//

import Foundation
import StoreKit

open class RCStoreProductsnfoDataProvider {
    struct InAppProductQuery {
        let request: RCInAppProductRequest
        var completionHandlers: [RCProductRequestCallback]
    }

    private var inflightRequests: [Set<String>: InAppProductQuery] = [:]

    @discardableResult
    func getProductsInfo(_ productIds: Set<String>, completion: @escaping (RetrieveResults) -> Void) -> RCInAppProductRequest {
        if inflightRequests[productIds] == nil {
            let request = request(productIds: productIds) { results in

                if let query = self.inflightRequests[productIds] {
                    for completion in query.completionHandlers {
                        completion(results)
                    }
                    self.inflightRequests[productIds] = nil
                } else {
                    completion(results)
                }
            }
            inflightRequests[productIds] = InAppProductQuery(request: request, completionHandlers: [completion])
            request.start()

            return request

        } else {
            inflightRequests[productIds]!.completionHandlers.append(completion)

            let query = inflightRequests[productIds]!

            if query.request.hasCompleted {
                query.completionHandlers.forEach {
                    $0(query.request.cachedResults!)
                }
            }

            return inflightRequests[productIds]!.request
        }
    }
}

extension RCStoreProductsnfoDataProvider {
    private func request(productIds: Set<String>, callback: @escaping RCProductRequestCallback) -> RCInAppProductRequest {
        RCAppStoreRequest(productIds: productIds, callback: callback)
    }
}
