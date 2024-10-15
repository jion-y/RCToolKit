//
//  RCProtocol.swift
//  RCToolKit
//
//  Created by yoyo on 2024/10/14.
//

import Foundation
public  protocol EmptyAble:Any {
    associatedtype T
    var empty:T { get }
}
