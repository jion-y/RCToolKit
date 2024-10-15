//
//  UICollectionViewCell+Extension.swift
//  RCToolKit
//
//  Created by yoyo on 2024/10/14.
//

import Foundation

//public typealias Codable = Decodable & Encodable

public extension ExtensionWrapper where Base:UICollectionViewCell  {
    @discardableResult
    func addView(view:UIView?) -> ExtensionWrapper {
        guard let v = view else { return self }
        self.base.contentView.addSubview(v)
        return self
    }
}

public extension ExtensionWrapper where Base:UITableViewCell  {
    @discardableResult
    func addView(view:UIView?) -> ExtensionWrapper {
        guard let v = view else { return self }
        self.base.contentView.addSubview(v)
        return self
    }
}
