//
//  RCReceiptRefresh.swift
//  RCToolKit
//
//  Created by yoyo on 2025/7/23.
//

import Foundation
import StoreKit
public class RCReceiptRefresh: NSObject {
     public static var `default` = RCReceiptRefresh()
    private var currentRequest: SKReceiptRefreshRequest?
    private var continuation: CheckedContinuation<Data, Error>?
    
    public func fetchReceipt() async throws -> Data {
        // 取消之前的请求
        currentRequest?.cancel()
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            
            // 创建新请求
            let request = SKReceiptRefreshRequest(receiptProperties: nil)
            request.delegate = self
            currentRequest = request
            request.start()
        }
    }
}

extension RCReceiptRefresh: @preconcurrency SKRequestDelegate {
    public func requestDidFinish(_ request: SKRequest) {
        DispatchQueue.main.async {
            do {
                guard let receiptUrl = Bundle.main.appStoreReceiptURL else {
                    throw NSError(domain: "RCReceiptRefresh", code: -1, userInfo: [NSLocalizedDescriptionKey: "无法获取收据URL"])
                }
                let receiptData = try Data(contentsOf: receiptUrl, options: .alwaysMapped)
                self.continuation?.resume(returning: receiptData)
                RCLog.rc.logInfo(message: "更新收据成功!")
            } catch {
                self.continuation?.resume(throwing: error)
                RCLog.rc.logInfo(message: "收据获取失败: \(error)")
            }
            self.continuation = nil
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.continuation?.resume(throwing: error)
            self.continuation = nil
            RCLog.rc.logInfo(message: "更新收据失败! error \(error.localizedDescription)")
        }
    }
}
