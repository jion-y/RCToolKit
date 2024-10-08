//
//  UIColor+Extension.swift
//  RCToolKit
//
//  Created by yoyo on 2022/10/21.
//

import Foundation
extension UIImage: ExtensionCompatibleValue {}
public extension ExtensionWrapper where Base == UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        base.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }

    var r: CGFloat {
        return rgba.red
    }

    var g: CGFloat {
        return rgba.green
    }

    var b: CGFloat {
        return rgba.blue
    }

    var a: CGFloat {
        return rgba.alpha
    }
    
    var cyan:CGFloat {
        return cmyk.c
    }
    var magneta:CGFloat{
        return cmyk.m
    }
    var yellow:CGFloat {
        return cmyk.yellow
    }
    var black:CGFloat {
        return cmyk.k
    }
    
    var cmyk:(c: CGFloat, m: CGFloat, yellow: CGFloat, k: CGFloat) {
        let rgba = rgba
        let k = max(rgba.green, max(rgba.red, rgba.blue))
        let c = (1 - rgba.red - k) / ( 1 - k )
        let m = (1 - rgba.green - k) / ( 1 - k )
        let y = (1 - rgba.blue - k) /  ( 1 - k )
        return (c,m,y,k)
    }
    
}

public extension ExtensionWrapper where Base == UIColor.Type {
    func rgba(r: UInt, g: UInt, b: UInt, a: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    func hexString(_ hexString: String) ->UIColor {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    // MARK: - 一下颜色为中国传统色
    /// 暗紫玉
    var anyuzi:UIColor {
        return hexString("#5C2223")
    }
    ///牡丹红
    var mudanfenhong:UIColor {
        return hexString("#EEA2A4")
    }
    ///栗紫
    var lizi:UIColor {
        return hexString("#5A191B")
    }
    ///香叶紫
    var xiangyehong:UIColor {
        return hexString("#F07C82")
    }
    ///葡萄紫
    var putaojiangzi:UIColor{
        return hexString("#5A1216")
    }
    /// 艳红
    var brilliant:UIColor {
        return hexString("#ED5A65")
    }
    ///玉红
    var yuhong:UIColor {
        return hexString("#C04851")
    }
    ///茶花红
    var chahuahong:UIColor {
        return hexString("#EE3F4D")
    }
    ///高粱红
    var gaolianghong:UIColor {
        return hexString("#C02C38")
    }
    /// 满江红
    var manjianghong:UIColor {
        return hexString("#A7535A")
    }
    ///鼠鼻红
    var shubihong:UIColor {
        return hexString("#E3B4B8")
    }
    ///合欢红
    var hehuanhong:UIColor {
        return hexString("#E3B4B8")
    }
    ///春梅红
    var chunmeihong:UIColor {
        return hexString("#F1939C")
    }
    ///苋菜红
    var xiancaihong:UIColor {
        return hexString("#A61B29")
    }
    ///烟红
    var yanhong:UIColor {
        return hexString("#894E54")
    }
    ///莓红
    var meihong:UIColor {
        return hexString("#C45A65")
    }
    
    ///鹅冠红
    var eguanhong:UIColor {
        return hexString("#D11A2D")
    }
    ///枫叶红
    var fengyehong:UIColor {
        return hexString("#C21F30")
    }
    
    /// 唐菖蒲红
    var tangchangpuhong:UIColor {
        return hexString("#DE1C31")
    }
    
    ///枣红
    var zaohong:UIColor {
        return hexString("#7C1823")
    }
    
    ///猪肝紫
    var zhuganzi:UIColor {
        return hexString("#541E24")
    }
    ///葡萄紫
    var putaozi:UIColor {
        return hexString("#4C1F24")
    }
    ///暗紫苑红
    var anziyuanhong:UIColor {
        return hexString("#82202B")
    }
    ///殷红
    var darkishRed:UIColor {
        return hexString("#82111F")
    }
    ///草茉莉红
    var caomolihong:UIColor {
        return hexString("#EF475D")
    }
    ///酱紫
    var jiangzi:UIColor {
        return hexString("#4D1018")
    }
    
    //山茶红
    var shanchahong:UIColor {
        return hexString("#ED556A")
    }
    ///锌灰
    var xinhui:UIColor {
        return hexString("#7A7374")
    }
    ///海棠红
    var haitanghong:UIColor {
        return hexString("#EE2746")
    }
    ///李紫
    var plumPurple:UIColor {
        return hexString("#2B1216")
    }
    
    ///石竹红
    var shizhuhong:UIColor {
        return hexString("#EE4863")
    }
    ///淡茜红
    var danqianhong:UIColor {
        return hexString("#E77C8E")
    }
    ///金鱼紫色
    var jinyuzi:UIColor {
        return hexString("#500a16")
    }
    ///山梨豆红
    var shanlidouhong:UIColor {
        return hexString("#c27c88")
    }
    ///鼠背灰
    var shubeihui:UIColor {
        return hexString("#73575c")
    }
    ///淡蕊香红
    var danruixianghong:UIColor {
        return hexString("#ee4866")
    }
    
    ///甘蔗紫
    var ganzhezi:UIColor {
        return hexString("#621624")
    }
    ///月季红
    var yuejihong:UIColor {
        return hexString("#ce5777")
    }
    ///尖晶玉红
    var jianjingyuhong:UIColor {
        return hexString("#cc163a")
    }
}
