//
//  RCFileLog.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/8.
//

import Foundation
public class RCFileLog: NSObject {
    public var logCacheSize: Int = 10
    public var logDir: String {
        set {
            if newValue.rc.isEmpty { return }
            if logDir_ == nil || logDir_ != newValue {
                logDir_ = newValue
                let rst = FileManager.default.rc.createDirectory(logDir_!)
                assert(rst == true, "dir path \(newValue) create failure")
            }
        }
        get {
            guard let dir = logDir_ else {
                logDir_ = defaultLogDir()
                let rst = FileManager.default.rc.createDirectory(logDir_!)
                assert(rst == true, "dir path \(logDir_!) create failure")
                return logDir_!
            }
            return dir
        }
    }
    
    private var logDir_: String?
    private var fomatter_: logFomatreralbel?
    private var logMemoryCache: ThreadSafeArray<String> = ThreadSafeArray()
    private let writeFileQueue = DispatchQueue(label: "com.rc-log.writeFileQueue")
    private var file: File?
    private let dateFormatter = DateFormatter()
    
    deinit {
        writeLogToFile()
    }
}

extension RCFileLog: LogOutputable {
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
        logMemoryCache.append(fmatter.formatter(msg))
        if logMemoryCache.count >= logCacheSize {
            writeLogToFile()
        }
    }

    public func flush() {
        writeLogToFile()
    }
}

extension RCFileLog {
    private func writeLogToFile() {
        writeFileQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            var totoalLog: String = String.rc.empty
            strongSelf.logMemoryCache.forEach { str in
                totoalLog += (str + "\n")
            }
            if strongSelf.file == nil {
                strongSelf.dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
                let logPath = strongSelf.logDir + strongSelf.dateFormatter.string(from: Date.rc.now) + ".log"
                strongSelf.file = File(logPath, mode: "aw+")
            }
            strongSelf.file?.writeStringToFile(str: totoalLog)
            strongSelf.logMemoryCache.removeAll()
        }
    }
    
    private func defaultLogDir() -> String {
        var identifier = Bundle.main.bundleIdentifier ?? "com.rc.cache"
        identifier += "_log"
        let cachePath = FileManager.default.rc.cachePath()
        let defaultLogDir = cachePath + "/" + identifier + "/"
        return defaultLogDir
    }
}
