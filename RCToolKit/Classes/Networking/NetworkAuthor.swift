//
//  NetworkAuthor.swift
//  RCToolKit
//
//  Created by yoyo on 2025/12/26.
//

import Combine
import CoreTelephony
import Foundation

@MainActor
public final class NetworkAuthor {
    public static let shared = NetworkAuthor()
    
    private var cellularData: CTCellularData?
    
    public var restrictedState: CTCellularDataRestrictedState {
        cellularData?.restrictedState ?? .restrictedStateUnknown
    }
    
    private init() {
        cellularData = CTCellularData()
    }
    
    public func checkCellularDataPermission() async -> CTCellularDataRestrictedState {
#if targetEnvironment(simulator)
        return .notRestricted
#else
        // 直接返回当前状态
        let state = cellularData?.restrictedState ?? .restrictedStateUnknown
        if state == .restrictedStateUnknown || state == .restricted {
            for await rstate in monitorPermissionChanges() {
                print("权限变化: \(state)")
                return rstate
            }
        }
        return state
#endif
    }
    
    public func monitorPermissionChanges() -> AsyncStream<CTCellularDataRestrictedState> {
        AsyncStream { continuation in
            guard let cellularData = cellularData else {
                continuation.finish()
                return
            }
            
            // 发送当前状态
            continuation.yield(cellularData.restrictedState)
            
            // 设置回调监听变化
            cellularData.cellularDataRestrictionDidUpdateNotifier = { state in
                continuation.yield(state)
            }
            
            // 在流结束时清理
            continuation.onTermination = { [weak cellularData] _ in
                cellularData?.cellularDataRestrictionDidUpdateNotifier = nil
            }
        }
    }
}
