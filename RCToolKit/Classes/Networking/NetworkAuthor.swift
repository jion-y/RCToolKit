import CoreTelephony
import Foundation

@MainActor
public final class NetworkAuthor {
  public static let shared = NetworkAuthor()

  private let cellularData: CTCellularData
  private var currentState: CTCellularDataRestrictedState
  private var pendingChecks: [UUID: CheckedContinuation<CTCellularDataRestrictedState, Never>] = [:]
  private var monitors: [UUID: AsyncStream<CTCellularDataRestrictedState>.Continuation] = [:]

  public var currentPermissionState: CTCellularDataRestrictedState {
    currentState
  }

  private init() {
    cellularData = CTCellularData()
    currentState = cellularData.restrictedState
    cellularData.cellularDataRestrictionDidUpdateNotifier = { [weak self] state in
      Task { @MainActor in
        self?.handleStateUpdate(state)
      }
    }
  }

  deinit {
    cellularData.cellularDataRestrictionDidUpdateNotifier = nil
  }

  private func handleStateUpdate(_ state: CTCellularDataRestrictedState) {
    currentState = state
    for (_, m) in monitors {
      m.yield(state)
    }
    if state != .restrictedStateUnknown {
      for (_, c) in pendingChecks {
        c.resume(returning: state)
      }
      pendingChecks.removeAll()
    }
  }

  public func stopMonitoring() {
    for (_, m) in monitors {
      m.finish()
    }
    monitors.removeAll()
  }

  public func getPermissionState() -> CTCellularDataRestrictedState {
    currentPermissionState
  }

  public func isPermissionRestricted() -> Bool {
    currentPermissionState == .restricted
  }

  public func isPermissionGranted() -> Bool {
    currentPermissionState == .notRestricted
  }

  public func isPermissionStateKnown() -> Bool {
    currentPermissionState != .restrictedStateUnknown
  }

  public func checkCellularDataPermission(timeoutSeconds: Double = 5) async -> CTCellularDataRestrictedState {
    await fetchPermissionState(timeoutSeconds: timeoutSeconds)
  }

  public func fetchPermissionState(timeoutSeconds: Double = 5) async -> CTCellularDataRestrictedState {
    #if targetEnvironment(simulator)
    return .notRestricted
    #else
    if isPermissionStateKnown() {
      return currentPermissionState
    }
    return await withCheckedContinuation { continuation in
      let id = UUID()
      pendingChecks[id] = continuation
      Task.detached { [weak self] in
        try await Task.sleep(nanoseconds: UInt64(timeoutSeconds * 1_000_000_000))
        await MainActor.run {
          guard let self = self else { return }
          if let c = self.pendingChecks[id] {
            c.resume(returning: self.currentPermissionState)
            self.pendingChecks.removeValue(forKey: id)
          }
        }
      }
    }
    #endif
  }

  public func monitorPermissionChanges() -> AsyncStream<CTCellularDataRestrictedState> {
    AsyncStream { continuation in
      let id = UUID()
      monitors[id] = continuation
      continuation.yield(currentPermissionState)
      continuation.onTermination = { _ in
        Task { @MainActor in
          self.monitors.removeValue(forKey: id)
        }
      }
    }
  }
}
