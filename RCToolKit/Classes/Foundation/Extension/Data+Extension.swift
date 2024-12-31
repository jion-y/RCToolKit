//
//  Data+Extension.swift
//  RCToolKit
//
//  Created by yoyo on 2024/10/16.
//

import CommonCrypto
import Foundation
extension Data:ExtensionCompatible {}
public extension ExtensionWrapper where Base == Data {
    var md5Str: String {
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))

        #if swift(>=5.0)
        _ = base.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            CC_MD5(bytes.baseAddress, CC_LONG(base.count), &digest)
        }
        #else
        _ = base.withUnsafeBytes { bytes in
            CC_MD5(bytes, CC_LONG(data.count), &digest)
        }

        #endif
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
