//
//  File.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/9.
//

import Foundation
/// 封装 c 的 File 操作
///
public class File {
    private var filePointer: UnsafeMutablePointer<FILE>?
    private var logFilePath: String?
    init(_ path: String, mode: String) {
        logFilePath = path
        filePointer = fopen(path, mode)
    }
    
    func writeStringToFile(str: String) {
        guard let data = str.data(using: .utf8) else {
            return
        }
        writeDataToFile(data)
    }
    
    deinit {
        if let fptr = filePointer {
            fclose(fptr)
            filePointer = nil
        }
    }
    
    func writeDataToFile(_ data: Data) {
        data.withUnsafeBytes { ptr in
#if os(Windows)
            _lock_file(filePointer)
#else
            flockfile(filePointer)
#endif
            defer {
#if os(Windows)
                _unlock_file(filePointer)
#else
                funlockfile(filePointer)
#endif
            }
            if let baseAdd = ptr.baseAddress {
                let wrst = fwrite(baseAdd, MemoryLayout<Int8>.size, ptr.count, filePointer)
            
            } else {
                print(" base addr nil")
            }
        }
        _ = fflush(filePointer)
    }
}
