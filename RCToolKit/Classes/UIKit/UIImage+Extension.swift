//
//  UIImage+Extension.swift
//  RCToolKit
//
//  Created by yoyo on 2022/9/20.
//

import Accelerate
import Foundation
import UIKit

extension CVPixelBuffer: ExtensionCompatibleValue {}
extension CIImage: ExtensionCompatibleValue {}
extension CGImage: ExtensionCompatibleValue {}

enum RCImageError:Error {
     case failure
     case noFace
}

public enum UIImageContentMode {
    case scaleToFill, scaleAspectFit, scaleAspectFill
}

public extension ExtensionWrapper where Base == UIImage {
    var size: CGSize { return base.size }
    var hasAlpha: Bool {
        let alpha: CGImageAlphaInfo = base.cgImage!.alphaInfo
        switch alpha {
        case .first, .last, .premultipliedFirst, .premultipliedLast:
            return true
        default:
            return false
        }
    }

    func applyAlpha()->UIImage? {
        if hasAlpha {
            return base
        }

        let imageRef = base.cgImage
        let width = imageRef?.width
        let height = imageRef?.height
        let colorSpace = imageRef?.colorSpace

        // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        let offscreenContext = CGContext(data: nil, width: width!, height: height!, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace!, bitmapInfo: bitmapInfo.rawValue)

        // Draw the image into the context and retrieve the new image, which will now have an alpha layer
        let rect = CGRect(x: 0, y: 0, width: CGFloat(width!), height: CGFloat(height!))
        offscreenContext?.draw(imageRef!, in: rect)
        let imageWithAlpha = UIImage(cgImage: (offscreenContext?.makeImage()!)!)
        return imageWithAlpha
    }

    // 简单高斯模糊
    func blurry(level: CGFloat)->UIImage? {
        guard let ciImage = base.ciImage else {
            return nil
        }
        let filter = CIFilter(name: "CIGaussianBlur", parameters: [kCIInputImageKey: ciImage, "inputRadius": level])
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
        let targetSize = CGSize(width: size.width / radio, height: size.height / radio)
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

    func circle(direction: UIRectCorner, radii: CGFloat, borderWidht: CGFloat, borderColor: UIColor, bgColor: UIColor)->UIImage? {
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
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: direction, cornerRadii: CGSize(width: newRadii - borderWidht, height: newRadii - borderWidht))
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
        let data = base.pngData()
        return data?.base64EncodedString(options: .lineLength64Characters)
    }

    func pixelBuffer(width: Int, height: Int)->CVPixelBuffer? {
        var maybePixelBuffer: CVPixelBuffer?
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                     kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue]
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(width),
                                         Int(height),
                                         kCVPixelFormatType_32ARGB,
                                         attrs as CFDictionary,
                                         &maybePixelBuffer)

        guard status == kCVReturnSuccess, let pixelBuffer = maybePixelBuffer else {
            return nil
        }

        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)

        guard let context = CGContext(data: pixelData,
                                      width: Int(width),
                                      height: Int(height),
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        else {
            return nil
        }

        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: 1, y: -1)

        UIGraphicsPushContext(context)
        base.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))

        return pixelBuffer
    }

    func image(gradientColors: [UIColor], locations: [Float] = [], blendMode: CGBlendMode = CGBlendMode.normal) ->UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, base.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(blendMode)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        context?.draw(base.cgImage!, in: rect)
        // Create gradient
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = gradientColors.map { (color: UIColor)->AnyObject? in color.cgColor as AnyObject? } as NSArray
        let gradient: CGGradient
        if locations.count > 0 {
            let cgLocations = locations.map { CGFloat($0) }
            gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: cgLocations)!
        } else {
            gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)!
        }
        // Apply gradient
        context?.clip(to: rect, mask: base.cgImage!)
        context?.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: size.height), options: CGGradientDrawingOptions(rawValue: 0))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    func apply(padding: CGFloat)->UIImage? {
        // If the image does not have an alpha layer, add one
        let image = applyAlpha()
        if image == nil {
            return nil
        }
        let rect = CGRect(x: 0, y: 0, width: size.width + padding * 2, height: size.height + padding * 2)

        // Build a context that's the same dimensions as the new size
        let colorSpace = base.cgImage?.colorSpace
        let bitmapInfo = base.cgImage?.bitmapInfo
        let bitsPerComponent = base.cgImage?.bitsPerComponent
        let context = CGContext(data: nil, width: Int(rect.size.width), height: Int(rect.size.height), bitsPerComponent: bitsPerComponent!, bytesPerRow: 0, space: colorSpace!, bitmapInfo: (bitmapInfo?.rawValue)!)

        // Draw the image in the center of the context, leaving a gap around the edges
        let imageLocation = CGRect(x: padding, y: padding, width: image!.size.width, height: image!.size.height)
        context?.draw(base.cgImage!, in: imageLocation)

        // Create a mask to make the border transparent, and combine it with the image
        let transparentImage = UIImage(cgImage: (context?.makeImage()?.masking(imageRef(withPadding: padding, size: rect.size))!)!)
        return transparentImage
    }

    func imageRef(withPadding padding: CGFloat, size: CGSize)->CGImage {
        // Build a context that's the same dimensions as the new size
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.none.rawValue)
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

        // Start with a mask that's entirely transparent
        context?.setFillColor(UIColor.black.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))

        // Make the inner part (within the border) opaque
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(CGRect(x: padding, y: padding, width: size.width - padding * 2, height: size.height - padding * 2))

        // Get an image of the context
        let maskImageRef = context?.makeImage()
        return maskImageRef!
    }

    func resize(toSize: CGSize, contentMode: UIImageContentMode = .scaleToFill)->UIImage? {
        let horizontalRatio = size.width / size.width
        let verticalRatio = size.height / size.height
        var ratio: CGFloat!

        switch contentMode {
        case .scaleToFill:
            ratio = 1
        case .scaleAspectFill:
            ratio = max(horizontalRatio, verticalRatio)
        case .scaleAspectFit:
            ratio = min(horizontalRatio, verticalRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: size.width * ratio, height: size.height * ratio)

        // Fix for a colorspace / transparency issue that affects some types of
        // images. See here: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/comment-page-2/#comment-39951

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(rect.size.width), height: Int(rect.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

        let transform = CGAffineTransform.identity

        // Rotate and/or flip the image if required by its orientation
        context?.concatenate(transform)

        // Set the quality level to use when rescaling
        context!.interpolationQuality = CGInterpolationQuality(rawValue: 3)!

        // CGContextSetInterpolationQuality(context, CGInterpolationQuality(kCGInterpolationHigh.value))

        // Draw into the context; this scales the image
        context?.draw(base.cgImage!, in: rect)

        // Get the resized image from the context and a UIImage
        let newImage = UIImage(cgImage: (context?.makeImage()!)!, scale: base.scale, orientation: base.imageOrientation)
        return newImage
    }
    @available(iOS 13.0.0, *)
    func faceRecognition() async -> [CIFaceFeature]? {
          await  withCheckedContinuation { continuation in
              DispatchQueue.global().async {
                guard let personciImage = CIImage(image: base) else {
                    continuation.resume(returning: nil)
                    return
                }
                let result = personciImage.rc.detecteface()
                  continuation.resume(returning:result)
            }
        }
    }
}

public extension ExtensionWrapper where Base == UIImage.Type {
    func image(base64Str: String)->UIImage? {
        guard let data = Data(base64Encoded: base64Str) else { return nil }
        return UIImage(data: data)
    }

    // kCVPixelFormatType_32BGRA
    func image(rgba: UnsafeMutableRawPointer, size: CGSize, pixelFormat: OSType)->UIImage? {
        var pixel: CVPixelBuffer?
        let rst = CVPixelBufferCreateWithBytes(nil, Int(size.width), Int(size.height), pixelFormat, rgba, Int(size.width) * 4, nil, nil, nil, &pixel)
        if rst != noErr {
            print("create pixelbuffer failure ")
            return nil
        }
        guard let cvpixelBuffer = pixel else {
            return nil
        }
        let ciImage = CIImage(cvPixelBuffer: cvpixelBuffer)
        return UIImage(ciImage: ciImage)
    }

    func image(color: UIColor, size: CGSize = CGSize(width: 10, height: 10))->UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func image(gradientColors: [UIColor], size: CGSize = CGSize(width: 10, height: 10), locations: [Float] = []) ->UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = gradientColors.map { (color: UIColor)->AnyObject? in color.cgColor as AnyObject? } as NSArray
        let gradient: CGGradient
        if locations.count > 0 {
            let cgLocations = locations.map { CGFloat($0) }
            gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: cgLocations)!
        } else {
            gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: nil)!
        }
        context!.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: size.height), options: CGGradientDrawingOptions(rawValue: 0))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func image(text: String, font: UIFont = UIFont.systemFont(ofSize: 18), color: UIColor = UIColor.white, backgroundColor: UIColor = UIColor.gray, size: CGSize = CGSize(width: 100, height: 100), offset: CGPoint = CGPoint(x: 0, y: 0)) ->UIImage? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        label.font = font
        label.text = text
        label.textColor = color
        label.textAlignment = .center
        label.backgroundColor = backgroundColor

        let image = UIImage.rc.image(fromView: label)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let rst = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rst
    }

    func image(fromView view: UIView) ->UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        // view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    func image(startColor: UIColor, endColor: UIColor, radialGradientCenter: CGPoint = CGPoint(x: 0.5, y: 0.5), radius: Float = 0.5, size: CGSize = CGSize(width: 100, height: 100))->UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, 0)

        let num_locations = 2
        let locations: [CGFloat] = [0.0, 1.0] as [CGFloat]

        let startComponents = startColor.cgColor.components!
        let endComponents = endColor.cgColor.components!

        let components: [CGFloat] = [startComponents[0], startComponents[1], startComponents[2], startComponents[3], endComponents[0], endComponents[1], endComponents[2], endComponents[3]]

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: components, locations: locations, count: num_locations)

        // Normalize the 0-1 ranged inputs to the width of the image
        let aCenter = CGPoint(x: radialGradientCenter.x * size.width, y: radialGradientCenter.y * size.height)
        let aRadius = CGFloat(min(size.width, size.height)) * CGFloat(radius)

        // Draw it
        UIGraphicsGetCurrentContext()?.drawRadialGradient(gradient!, startCenter: aCenter, startRadius: 0, endCenter: aCenter, endRadius: aRadius, options: CGGradientDrawingOptions.drawsAfterEndLocation)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // Clean up
        UIGraphicsEndImageContext()
        return image
    }
    
    func image(bundle:String,imageName:String)->UIImage? {
        guard  let bundlePath = Bundle.main.path(forResource: bundle, ofType: ".bundle") else {
            return nil
        }
       let dble = Bundle(url: URL(fileURLWithPath: bundlePath))
        guard  let imagePath = dble?.path(forResource: imageName, ofType:nil) else {
            return nil
        }
        return  UIImage(named: imageName, in: dble,compatibleWith: .none)
    }
    
}

public extension ExtensionWrapper where Base == CVPixelBuffer {
    func resizePixelBuffer(cropX: Int,
                           cropY: Int,
                           cropWidth: Int,
                           cropHeight: Int,
                           scaleWidth: Int,
                           scaleHeight: Int)->CVPixelBuffer?
    {
        CVPixelBufferLockBaseAddress(base, CVPixelBufferLockFlags(rawValue: 0))
        guard let srcData = CVPixelBufferGetBaseAddress(base) else {
            print("Error: could not get pixel buffer base address")
            return nil
        }
        let srcBytesPerRow = CVPixelBufferGetBytesPerRow(base)
        let offset = cropY * srcBytesPerRow + cropX * 4
        var srcBuffer = vImage_Buffer(data: srcData.advanced(by: offset),
                                      height: vImagePixelCount(cropHeight),
                                      width: vImagePixelCount(cropWidth),
                                      rowBytes: srcBytesPerRow)

        let destBytesPerRow = scaleWidth * 4
        guard let destData = malloc(scaleHeight * destBytesPerRow) else {
            print("Error: out of memory")
            return nil
        }
        var destBuffer = vImage_Buffer(data: destData,
                                       height: vImagePixelCount(scaleHeight),
                                       width: vImagePixelCount(scaleWidth),
                                       rowBytes: destBytesPerRow)

        let error = vImageScale_ARGB8888(&srcBuffer, &destBuffer, nil, vImage_Flags(0))
        CVPixelBufferUnlockBaseAddress(base, CVPixelBufferLockFlags(rawValue: 0))
        if error != kvImageNoError {
            print("Error:", error)
            free(destData)
            return nil
        }

        let releaseCallback: CVPixelBufferReleaseBytesCallback = { _, ptr in
            if let ptr = ptr {
                free(UnsafeMutableRawPointer(mutating: ptr))
            }
        }

        let pixelFormat = CVPixelBufferGetPixelFormatType(base)
        var dstPixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreateWithBytes(nil, scaleWidth, scaleHeight,
                                                  pixelFormat, destData,
                                                  destBytesPerRow, releaseCallback,
                                                  nil, nil, &dstPixelBuffer)
        if status != kCVReturnSuccess {
            print("Error: could not create new pixel buffer")
            free(destData)
            return nil
        }
        return dstPixelBuffer
    }

    func resizePixelBuffer(_ width: Int, height: Int)->CVPixelBuffer? {
        return resizePixelBuffer(cropX: 0, cropY: 0,
                                 cropWidth: CVPixelBufferGetWidth(base),
                                 cropHeight: CVPixelBufferGetHeight(base),
                                 scaleWidth: width, scaleHeight: height)
    }
}

public extension ExtensionWrapper where Base == CIImage {
    func cgImgae()->CGImage? {
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(base, from: base.extent) {
            return cgImage
        }
        return nil
    }
    
    func detecteface() ->[CIFaceFeature]? {
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        return faceDetector?.features(in: base) as? [CIFaceFeature]
    }

}

public extension ExtensionWrapper where Base == CGImage {
    func ciImage()->CIImage? {
        return CIImage(cgImage: base)
    }
}

public extension ExtensionWrapper where Base == UIImage.Type {
    var empty: UIImage {
        get {
            return UIImage()
        }
    }
}
