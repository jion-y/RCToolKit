//
//  RCToast.swift
//  RCToolKit
//
//  Created by yoyo on 2024/10/24.
//

import Foundation
#if canImport(Toast_Swift)
import Toast_Swift
open class RCToast {
    open class func showString(str: String, position: ToastPosition = .center, view: UIView? = UIDevice.rc.keyWindow) {
        DispatchQueue.rc.safeRunMainQueue {
            guard let view = view else { return }
            view.makeToast(str, position: position)
        }

    }

    open class func showLoding() {
        DispatchQueue.rc.safeRunMainQueue {
            UIDevice.rc.keyWindow?.makeToastActivity(.center)
        }
    }

    open class func hiddenLoging() {
        DispatchQueue.rc.safeRunMainQueue {
            UIDevice.rc.keyWindow?.hideToastActivity()
        }
    }
}
#endif
