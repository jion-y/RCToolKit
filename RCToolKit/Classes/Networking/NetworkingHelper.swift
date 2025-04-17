//
//  NetworkingHelper.swift
//  RCToolKit
//
//  Created by yoyo on 2025/1/2.
//

import Foundation
public class NetworkingHelper {
    open class func isVpnOrProxyNetwork () ->Bool {
        guard  let dic = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? NSDictionary else {
            return false
        }
        var isVpn:Bool = false
        var isProxy:Bool = false
        if let allKeys = (dic["__SCOPED__"] as?  NSDictionary )?.allKeys as? Array<String> {
            isVpn =  allKeys.contains { key in
                return ( key.contains("tap") ||   key.contains("tun") ||  key.contains("ppp") )
            }
        }
        if let _ = dic["HTTPSProxy"] {
            isProxy = true
        }
        if  let _ = dic["HTTPProxy"] {
            isProxy = true
        }
        return (isVpn || isProxy)
    }
}
