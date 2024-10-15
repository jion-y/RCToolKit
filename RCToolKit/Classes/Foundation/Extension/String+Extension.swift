//
//  String+Extension.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/8.
//

import Foundation
extension String:ExtensionCompatible {}

public extension ExtensionWrapper where Base == String.Type {
    var empty:String { get { return "" }  }
 
}

public extension ExtensionWrapper where Base == String {
    var isEmpty:Bool { get { return base.isEmpty }  }
    
    func localize(bundle:String = "Main")->String {
        return Localized.getLocaizedString(for: base, in: bundle)
    }
    
    ///图片名称的字符串可以调这个方法直接加载对应的图片
    func loadToImage()->UIImage? {
     if self.isEmpty { return nil } 
      return UIImage(named: base)
    }
    ///文件路径字符串调用该方法直接读取文件内容
    func loadToData()->Data? {
        if !FileManager.default.rc.fileExist(atPath: base) {
            return nil
        }
        return try? Data(contentsOf: URL(fileURLWithPath: base))
    }
    
    var hexColor:UIColor {
        get {
            return UIColor.rc.hexString(self.base)
        }
    }
    
}


