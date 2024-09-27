//
//  DispatchQueue+Extension.swift
//  Alamofire
//
//  Created by yoyo on 2024/9/25.
//

import Foundation

public extension ExtensionWrapper where Base == DispatchQueue.Type {
    func safeRunMainQueue(execute work:@escaping @convention(block) () -> Void ){
        if  Thread.isMainThread {
            work()
        } else {
            base.main.async {
                work()
            }
        }
    }
}
