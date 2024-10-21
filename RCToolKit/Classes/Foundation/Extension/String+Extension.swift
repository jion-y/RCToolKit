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
    
    ///图片名称的字符串可以调这个方法直接加载对应的图片
    var image:UIImage? {
        get {
            if self.isEmpty { return nil }
            return UIImage(named: base)
        }
    }
    ///字符串调用该方法直接转成utf8的data
    var utf8Data:Data? {
        get {
            return base.data(using: .utf8)
        }
    }
    ///文件路径字符串调用该方法直接读取文件内容
    var fileData:Data? {
        get {
            if !FileManager.default.rc.fileExist(atPath: base) {
                return nil
            }
            
            return try? Data(contentsOf: URL(fileURLWithPath: base))
        }
    }
   /// 本地化字符串
    var localStr:String {
        get {
            return localize()
        }
    }
    
    func localize(bundle:String = "Main")->String {
        return Localized.getLocaizedString(for: base, in: bundle)
    }
    
    
    ///图片名称的字符串可以调这个方法直接加载对应的图片
    @available(*, deprecated, message: "准备放弃这种写法统一为 用更便捷的image 属性来替换")
    func loadToImage()->UIImage? {
        return self.image
    }
    ///文件路径字符串调用该方法直接读取文件内容
    @available(*, deprecated, message: "准备放弃这种写法统一为 用更便捷的data属性来替换")
    func loadToData()->Data? {
        return self.fileData
    }
    
    var hexColor:UIColor {
        get {
            return UIColor.rc.hexString(self.base)
        }
    }
    
    func jsonDecode<T>(type:T.Type) -> T? where T:Decodable {
        let jsonDecoder = JSONDecoder()
        guard let data = self.base.data(using: .utf8) , let value = try? jsonDecoder.decode(type, from: data) else {
            return nil
        }
        return value
        
    }
}


