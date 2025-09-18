//
//  Data+Extension.swift
//  RCToolKit
//
//  Created by yoyo on 2024/10/16.
//

import CommonCrypto
import Foundation
import CryptoKit
// 错误处理
enum EncryptionError: Error {
    case invalidKeySize
    case invalidData
    case decryptionFailed
    case decodingFailed
}
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
    
    // 加密函数
    func aesEncrypt(keyStr: String) throws -> Data {
        
        let key = try createKey(from: keyStr)
        let sealedBox = try AES.GCM.seal(base, using: key)
        return sealedBox.combined! // 包含 nonce + 密文 + tag
    }
    // 解密函数
    func decrypt(keyStr: String) throws -> Data {
        let key = try createKey(from: keyStr)
        let sealedBox = try AES.GCM.SealedBox(combined: base)
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        return decryptedData
    }
    
    // 将字符串转换为256位密钥
    func createKey(from string: String) throws -> SymmetricKey {
        // 将字符串转换为Data
        guard var keyData = string.data(using: .utf8) else {
            throw EncryptionError.invalidKeySize
        }
        
        // 检查并调整密钥长度
        if keyData.count > 32 {
            // 如果超过32字节，截断
            keyData = keyData.prefix(32)
        } else if keyData.count < 32 {
            // 如果不足32字节，用0填充
            keyData.append(contentsOf: [UInt8](repeating: 0, count: 32 - keyData.count))
        }
        
        return SymmetricKey(data: keyData)
    }
}

