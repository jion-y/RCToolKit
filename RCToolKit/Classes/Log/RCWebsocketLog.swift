//
//  RCWebsocketLog.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/9.
//

import Foundation
import CocoaAsyncSocket
/// 这个类旨在通过 websocket 形式将 log 输出到其他端。
/// 主要是想解决 测试环节中出现问题不方便查看 log 的情况
///

public class RCWebsocketLog:NSObject {
    private var fomatter_: logFomatreralbel?
    
    private var socketClient:GCDAsyncSocket?
    private let queue = DispatchQueue(label: "com.rc.websocketQueue")
    public override init() {
        super.init()
        self.socketClient = GCDAsyncSocket(delegate: self, delegateQueue: queue)
    }
}
@available(iOS 13.0, *)
extension RCWebsocketLog: LogOutputable {
    public var formatter: logFomatreralbel? {
        get {
            guard let fmatter = fomatter_ else {
                fomatter_ = RCDefaultFormatter.default
                return fomatter_!
            }
            return fmatter
        }
        set {
            fomatter_ = newValue
        }
    }

    public func logMessage(msg: RCLogMessage) {
        guard let fmatter = formatter else { return }
//        let str = fmatter.formatter(msg, emo: true);
    }

    public func flush() {
    }
}
extension RCWebsocketLog:GCDAsyncSocketDelegate {
    public func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
      //上报身份986777777777777777777777779
    }
    public func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        sock .readData(withTimeout: -1, tag: tag)
        //收到 msg
        
        
    }
    
}
