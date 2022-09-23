//
//  UIImage+Extension.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/20.
//

import Foundation
import UIKit
public extension ExtensionWrapper where Base == UIImage {
    
    var size:CGSize { return base.size }
    // 简单高斯模糊
    func blurry(level: CGFloat)->UIImage? {
        guard let ciImage = base.ciImage else {
            return nil
        }
        let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: [kCIInputImageKey: ciImage, "inputRadius": level])
        guard let outputCIImage = filter?.outputImage else { return nil }
        return UIImage(ciImage: outputCIImage)
    }

    func boxBlur(blurImage: UIImage) {}
    
    func scaleTo(size: CGSize) ->UIImage? {
        var width = base.size.width * 1.0
        var heigth = base.size.height * 1.0
        let hRadio = size.width / width
        let vRadio = size.height / heigth
        let radio = min(hRadio, vRadio)
        width = width * radio
        heigth = heigth * radio
        let x = (size.width - width) / 2.0
        let y = (size.height - heigth) / 2.0
        UIGraphicsBeginImageContext(size)
        base.draw(in: CGRect(x: x, y: y, width: width, height: heigth))
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        return outputImage
    }
    
    // 将图片最长边缩放到 maxLength，短边等比缩放
    func scaleToMaxLength(maxLength: CGFloat)->UIImage? {
        let size = base.size
        let imageMaxLenght = max(size.width, size.height)
        let radio = imageMaxLenght / maxLength
        let targetSize = CGSize(width: size.width * radio, height: size.height * radio)
        return scaleTo(size: targetSize)
    }
    
    /// 区域裁剪
    func copping(rect: CGRect) ->UIImage? {
        guard let imageRef = base.cgImage else { return nil }
        guard let newImageRef = imageRef.cropping(to: rect) else { return nil }
        return UIImage(cgImage: newImageRef)
    }

    // 将原图裁剪成一张正方形图片
    func cropImageToSquare()->UIImage? {
        let size = base.size
        let minLength = min(size.width, size.height)
        let rect = CGRect(x: (size.width - minLength) / 2.0, y: (size.height - minLength) / 2.0, width: minLength, height: minLength)
        return copping(rect: rect)
    }
    
    func circle()->UIImage? {
        return circle(direction: .allCorners, radii: size.height / 2.0, borderWidht: 0, borderColor: .clear, bgColor: .clear)
    }
    
    func circle(direction:UIRectCorner,radii:CGFloat,borderWidht:CGFloat,borderColor:UIColor,bgColor:UIColor)->UIImage? {
        if size.equalTo(.zero) {
            return base
        }
        var newRadii = radii
        if newRadii <= 0 {
            newRadii = size.height / 2.0
        }
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        guard let currentCtx = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let path:UIBezierPath = UIBezierPath(roundedRect: rect, byRoundingCorners: direction, cornerRadii: CGSize(width: newRadii - borderWidht, height: newRadii - borderWidht))
        currentCtx.addPath(path.cgPath)
        currentCtx.clip()
        base.draw(in: rect)
        borderColor.setStroke()
        bgColor.setFill()
        path.fill()
        let rstImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rstImage
    }
    func base64()->String? {
        let data = UIImagePNGRepresentation(base)
        return data?.base64EncodedString(options: .lineLength64Characters)
    }
}

public extension ExtensionWrapper where Base == UIImage.Type {
    func image(base64Str:String)->UIImage? {
        guard let data = Data(base64Encoded: base64Str) else { return nil }
        return UIImage(data: data)
    }
    
    
    //https://github.com/hollance/YOLO-CoreML-MPSNNGraph/blob/master/TinyYOLO-CoreML/TinyYOLO-CoreML/CVPixelBuffer%2BHelpers.swift
    //kCVPixelFormatType_32BGRA
    func image(rgba:UnsafeMutableRawPointer,size:CGSize,pixelFormat:OSType)->UIImage? {
        var pixel:CVPixelBuffer?
        let rst = CVPixelBufferCreateWithBytes(nil, Int(size.width), Int(size.height), pixelFormat, rgba, Int(size.width) * 4, nil, nil, nil, &pixel)
        if rst != noErr {
            print("create pixelbuffer failure ")
            return nil
        }
        guard let cvpixelBuffer = pixel else {
            return nil
        }
        let ciImage =  CIImage(cvPixelBuffer: cvpixelBuffer)
        return UIImage(ciImage: ciImage)
    }
}
