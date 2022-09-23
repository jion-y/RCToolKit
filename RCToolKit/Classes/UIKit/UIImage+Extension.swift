//
//  UIImage+Extension.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/20.
//

import Foundation
import UIKit
extension ExtensionWrapper where Base: UIImage {
    //简单高斯模糊
    public func blurry(level:CGFloat)->UIImage? {
        guard let ciImage = base.ciImage else {
            return nil
        }
        let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: [kCIInputImageKey:ciImage,"inputRadius":level])
        guard  let outputCIImage = filter?.outputImage else { return nil }
        return UIImage(ciImage: outputCIImage)
    }
    public func boxBlur(blurImage:UIImage) {
        
    }
    
    public func scaleTo(size:CGSize) ->UIImage? {
        var width = base.size.width * 1.0
        var heigth = base.size.height * 1.0
        let hRadio = size.width / width;
        let vRadio = size.height / heigth;
        let radio = min(hRadio, vRadio)
        width  = width * radio
        heigth = heigth * radio
        let x = (size.width - width ) / 2.0
        let y = (size.height - heigth) / 2.0
        UIGraphicsBeginImageContext(size)
        base.draw(in: CGRect(x: x, y: y, width: width, height: heigth))
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        return outputImage
    }
    
    //将图片最长边缩放到 maxLength，短边等比缩放
    public func scaleToMaxLength(maxLength:CGFloat)->UIImage? {
        let size = base.size
        let imageMaxLenght = max(size.width, size.height)
        let radio = imageMaxLenght / maxLength
        let targetSize = CGSize(width: size.width * radio, height: size.height * radio)
        return scaleTo(size: targetSize)
    }
    
    /// 区域裁剪
    public func copping(rect:CGRect) ->UIImage? {
        guard  let imageRef = base.cgImage else { return nil }
        guard let newImageRef = imageRef.cropping(to: rect) else { return nil }
        return UIImage(cgImage: newImageRef)
    }
}
