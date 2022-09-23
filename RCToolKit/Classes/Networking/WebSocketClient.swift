//
//  WebSocketClient.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/9.
//

import Foundation
@available(iOS 13.0, *)
public protocol WebSocketClientDelegate {
    func recive(_ client:WebSocketClient,msg:String)
    func recive(_ client:WebSocketClient,data:Data)
}
@available(iOS 13.0, *)
public class WebSocketClient: NSObject,URLSessionWebSocketDelegate {
    private var url: String = String.rc.empty
    private var session: URLSession?
    private var websocketTask: URLSessionWebSocketTask?
    private let websocketQueue: DispatchQueue = .init(label: "com.rc.websocketQueue")
    private var pingPongTime: Timer?
    private var delegate:WebSocketClientDelegate?
    
    init(url: String,delegate:WebSocketClientDelegate?) {
        super.init()
        self.url = url
        self.session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
    }

    public func connection() {
        guard let requestURL = URL(string: self.url) else {
            return
        }
        var requst = URLRequest(url: requestURL)
        requst.timeoutInterval = 30
        requst.networkServiceType  = .networkServiceTypeCallSignaling
        self.websocketTask = self.session?.webSocketTask(with: requst)
        self.websocketTask?.resume()
    }

    public func sendMsg(msg: String) {
        self.websocketQueue.async {
            let socketMsg = URLSessionWebSocketTask.Message.string(msg)
            self.websocketTask?.send(socketMsg, completionHandler: {  error in
                if (error != nil) {
                    print(" send error \(error.debugDescription)")
                } else {
                    print("send succ")
                }
            })
            self.websocketTask?.resume()
        }
    }

    public func sendData(data: Data) {
        self.websocketQueue.async {
            let msg = URLSessionWebSocketTask.Message.data(data)
            self.websocketTask?.send(msg, completionHandler: { _ in
            })
        }
    }

    public func close() {
        self.websocketTask?.cancel(with: .goingAway, reason: "bye bye see you later".data(using: .utf8))
    }

    private func recive() {
        self.websocketTask?.receive(completionHandler: { result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    if let delegate = self.delegate {
                        delegate.recive(self, data: data)
                    }
                    break
                case .string(let str):
                    if let delegate = self.delegate {
                        delegate.recive(self, msg: str)
                    }
                    break
                default: break
                }
            case .failure:
                break
            }
            if self.websocketTask!.state == .running {
                self.recive()
            }
            
        })
    }

    @objc private func sendPingpong() {
        self.websocketQueue.async {
            self.websocketTask?.sendPing(pongReceiveHandler: { _ in
            })
        }
    }

    private func startTime() {
        self.stopTime()
        self.pingPongTime = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.sendPingpong), userInfo: nil, repeats: true)
    }

    private func stopTime() {
        guard let time = self.pingPongTime else { return }
        time.invalidate()
        self.pingPongTime = nil
    }
    
    // MARK: URLSESSION Protocols

    private func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Connected to server")
        self.startTime()
//        self.receive()
//        self.send()
    }

    private func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Disconnect from Server \(String(describing: reason))")
        self.stopTime()
    }
    func urlSession(_ session:URLSession, didReceive challenge:URLAuthenticationChallenge, completionHandler:@escaping (URLSession.AuthChallengeDisposition,URLCredential?) -> Void) {
   
              guard challenge.protectionSpace.authenticationMethod == "NSURLAuthenticationMethodServerTrust"else {
                  return
              }
   
              let credential = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
              completionHandler(.useCredential,credential)
        }
}
