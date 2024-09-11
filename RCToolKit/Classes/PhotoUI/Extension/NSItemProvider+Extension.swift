//
//  NSItemProvider+Extension.swift
//  Pods
//
//  Created by yoyo on 2024/8/4.
//

import Foundation
import PhotosUI
enum PhotoError:Error {
  case unknow
}
//extension NSItemProvider:ExtensionCompatible {}
@available(iOS 13.0.0, *)
public extension ExtensionWrapper where Base:NSItemProvider {

    func loadObject(ofClass aClass:NSItemProviderReading.Type) async ->NSItemProviderReading? {
        await withCheckedContinuation { continuation in
            base.loadObject(ofClass: aClass) { reading, error in
                    continuation.resume(returning: reading)
            }
        }
        
    }
}
