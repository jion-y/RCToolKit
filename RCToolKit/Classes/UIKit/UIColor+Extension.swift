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

    // MARK: - 中国传统色 (从JSON生成)
    // 注意: 以下颜色按拼音排序，已跳过重复定义

    /// 艾背绿
    var aibeilv: UIColor {
        return hexString("#dfecd5")
    }
    /// 艾绿
    var ailv: UIColor {
        return hexString("#cad3c3")
    }
    /// 安安蓝
    var ananlan: UIColor {
        return hexString("#3170a7")
    }
    /// 暗海水绿
    var anhaishuilv: UIColor {
        return hexString("#584717")
    }
    /// 暗蓝
    var anlan: UIColor {
        return hexString("#101f30")
    }
    /// 暗蓝紫
    var anlanzi: UIColor {
        return hexString("#131124")
    }
    /// 暗龙胆紫
    var anlongdanzi: UIColor {
        return hexString("#22202e")
    }
    /// 暗驼棕
    var antuozong: UIColor {
        return hexString("#592620")
    }
    /// 白芨红
    var baijihong: UIColor {
        return hexString("#de7897")
    }
    /// 百灵鸟灰
    var bailingniaohui: UIColor {
        return hexString("#b4a992")
    }

    /// 白屈菜绿
    var baiqucailv: UIColor {
        return hexString("#485b4d")
    }
    /// 蚌肉白
    var bangroubai: UIColor {
        return hexString("#f9f1db")
    }
    /// 斑鸠灰
    var banjiuhui: UIColor {
        return hexString("#482936")
    }
    /// 报春红
    var baochunhong: UIColor {
        return hexString("#ec8aa4")
    }
    /// 宝石蓝
    var baoshilan: UIColor {
        return hexString("#2486b9")
    }
    /// 宝石绿
    var baoshilv: UIColor {
        return hexString("#41ae3c")
    }
    /// 北瓜黄
    var beiguahuang: UIColor {
        return hexString("#fc8c23")
    }
    /// 扁豆花红
    var biandouhuahong: UIColor {
        return hexString("#ef498b")
    }
    /// 扁豆紫
    var biandouzi: UIColor {
        return hexString("#a35c8f")
    }
    /// 碧螺春绿
    var biluochunlv: UIColor {
        return hexString("#867018")
    }

    /// 槟榔综
    var binglangzong: UIColor {
        return hexString("#c1651a")
    }
    /// 冰山蓝
    var bingshanlan: UIColor {
        return hexString("#a4aca7")
    }
    /// 碧青
    var biqing: UIColor {
        return hexString("#5cb3cc")
    }
    /// 荸荠紫
    var biqizi: UIColor {
        return hexString("#411c35")
    }
    /// 菠根红
    var bogenhong: UIColor {
        return hexString("#d13c74")
    }
    /// 薄荷绿
    var bohelv: UIColor {
        return hexString("#207f4c")
    }
    /// 柏林蓝
    var bolinlan: UIColor {
        return hexString("#126bae")
    }
    /// 菠萝红
    var boluohong: UIColor {
        return hexString("#fc7930")
    }
    /// 菜头紫
    var caitouzi: UIColor {
        return hexString("#951c48")
    }
    /// 藏花红
    var canghuahong: UIColor {
        return hexString("#ec2d7a")
    }

    /// 苍黄
    var canghuang: UIColor {
        return hexString("#806332")
    }
    /// 苍蓝
    var canglan: UIColor {
        return hexString("#134857")
    }
    /// 苍绿
    var canglv: UIColor {
        return hexString("#223e36")
    }
    /// 苍蝇灰
    var cangyinghui: UIColor {
        return hexString("#36282b")
    }
    /// 草黄
    var caohuang: UIColor {
        return hexString("#d2b42c")
    }
    /// 草灰绿
    var caohuilv: UIColor {
        return hexString("#8e804b")
    }
    /// 草莓红
    var caomeihong: UIColor {
        return hexString("#ef6f48")
    }
    /// 草原远绿
    var caoyuanyuanlv: UIColor {
        return hexString("#9abeaf")
    }
    /// 草珠红
    var caozhuhong: UIColor {
        return hexString("#f8ebe6")
    }
    /// 茶褐
    var chahe: UIColor {
        return hexString("#5d3d21")
    }

    /// 长石灰
    var changshihui: UIColor {
        return hexString("#363433")
    }
    /// 蟾绿
    var chanlv: UIColor {
        return hexString("#3c9566")
    }
    /// 潮蓝
    var chaolan: UIColor {
        return hexString("#2983bb")
    }
    /// 炒米黄
    var chaomihuang: UIColor {
        return hexString("#f4ce69")
    }
    /// 橙皮黄
    var chengpihuang: UIColor {
        return hexString("#fca104")
    }
    /// 尘灰
    var chenhui: UIColor {
        return hexString("#b6a476")
    }
    /// 晨曦红
    var chenxihong: UIColor {
        return hexString("#ea8958")
    }
    /// 初荷红
    var chuhehong: UIColor {
        return hexString("#e16c96")
    }
    /// 初熟杏黄
    var chushuxinghuang: UIColor {
        return hexString("#f8bc31")
    }
    /// 初桃粉红
    var chutaofenhong: UIColor {
        return hexString("#f6dcce")
    }

    /// 葱绿
    var conglv: UIColor {
        return hexString("#40a070")
    }
    /// 翠蓝
    var cuilan: UIColor {
        return hexString("#1e9eb3")
    }
    /// 翠绿
    var cuilv: UIColor {
        return hexString("#20a162")
    }
    /// 酢酱草红
    var cujiangcaohong: UIColor {
        return hexString("#c5708b")
    }
    /// 大豆黄
    var dadouhuang: UIColor {
        return hexString("#fbcd31")
    }
    /// 大红
    var dahong: UIColor {
        return hexString("#f04b22")
    }
    /// 玳瑁黄
    var daimaohuang: UIColor {
        return hexString("#daa45a")
    }
    /// 大理石灰
    var dalishihui: UIColor {
        return hexString("#c4cbcf")
    }
    /// 蛋白石绿
    var danbaishilv: UIColor {
        return hexString("#579572")
    }
    /// 淡藏花红
    var dancanghuahong: UIColor {
        return hexString("#f6ad8f")
    }

    /// 淡翠绿
    var dancuilv: UIColor {
        return hexString("#c6dfc8")
    }
    /// 淡豆沙
    var dandousha: UIColor {
        return hexString("#873d24")
    }
    /// 胆矾蓝
    var danfanlan: UIColor {
        return hexString("#0f95b0")
    }
    /// 淡绯
    var danfei: UIColor {
        return hexString("#f2cac9")
    }
    /// 淡灰绿
    var danhuilv: UIColor {
        return hexString("#ad9e5f")
    }
    /// 淡绛红
    var danjianghong: UIColor {
        return hexString("#ec7696")
    }
    /// 淡茧黄
    var danjianhuang: UIColor {
        return hexString("#f9d770")
    }
    /// 淡橘橙
    var danjucheng: UIColor {
        return hexString("#fba414")
    }
    /// 淡咖啡
    var dankafei: UIColor {
        return hexString("#945833")
    }
    /// 蛋壳黄
    var dankehuang: UIColor {
        return hexString("#f8c387")
    }

    /// 淡可可棕
    var dankekezong: UIColor {
        return hexString("#b7511d")
    }
    /// 淡蓝灰
    var danlanhui: UIColor {
        return hexString("#5e7987")
    }
    /// 淡蓝紫
    var danlanzi: UIColor {
        return hexString("#a7a8bd")
    }
    /// 淡栗棕
    var danlizong: UIColor {
        return hexString("#673424")
    }
    /// 淡绿
    var danlv: UIColor {
        return hexString("#61ac85")
    }
    /// 淡绿灰
    var danlvhui: UIColor {
        return hexString("#70887d")
    }
    /// 淡玫瑰灰
    var danmeiguihui: UIColor {
        return hexString("#b89485")
    }
    /// 淡米粉
    var danmifen: UIColor {
        return hexString("#fbeee2")
    }
    /// 淡密黄
    var danmihuang: UIColor {
        return hexString("#f9d367")
    }
    /// 淡牵牛紫
    var danqianniuzi: UIColor {
        return hexString("#d1c2d3")
    }

    /// 淡青紫
    var danqingzi: UIColor {
        return hexString("#e0c8d1")
    }
    /// 淡肉色
    var danrouse: UIColor {
        return hexString("#f8e0b0")
    }
    /// 淡菽红
    var danshuhong: UIColor {
        return hexString("#ed4845")
    }
    /// 淡曙红
    var danshuhong_2: UIColor {
        return hexString("#ee2746")
    }
    /// 淡松烟
    var dansongyan: UIColor {
        return hexString("#4d4030")
    }
    /// 淡桃红
    var dantaohong: UIColor {
        return hexString("#f6cec1")
    }
    /// 淡藤萝紫
    var dantengluozi: UIColor {
        return hexString("#f2e7e5")
    }
    /// 淡铁灰
    var dantiehui: UIColor {
        return hexString("#5b423a")
    }
    /// 淡土黄
    var dantuhuang: UIColor {
        return hexString("#8c4b31")
    }
    /// 淡罂粟红
    var danyingsuhong: UIColor {
        return hexString("#eea08c")
    }

    /// 淡银灰
    var danyinhui: UIColor {
        return hexString("#c1b2a3")
    }
    /// 淡赭
    var danzhe: UIColor {
        return hexString("#be7e4a")
    }
    /// 丹紫红
    var danzihong: UIColor {
        return hexString("#d2568c")
    }
    /// 靛青
    var dianqing: UIColor {
        return hexString("#1661ab")
    }
    /// 电气石红
    var dianqishihong: UIColor {
        return hexString("#c35691")
    }
    /// 甸子蓝
    var dianzilan: UIColor {
        return hexString("#10aec2")
    }
    /// 凋叶棕
    var diaoyezong: UIColor {
        return hexString("#e7a23f")
    }
    /// 吊钟花红
    var diaozhonghuahong: UIColor {
        return hexString("#ce5e8a")
    }
    /// 貂紫
    var diaozi: UIColor {
        return hexString("#5d3131")
    }
    /// 蝶翅蓝
    var diechilan: UIColor {
        return hexString("#4e7ca1")
    }

    /// 蝶黄
    var diehuang: UIColor {
        return hexString("#e2d849")
    }
    /// 丁香淡紫
    var dingxiangdanzi: UIColor {
        return hexString("#e9d7df")
    }
    /// 丁香棕
    var dingxiangzong: UIColor {
        return hexString("#71361d")
    }
    /// 豆蔻紫
    var doukouzi: UIColor {
        return hexString("#ad6598")
    }
    /// 豆沙
    var dousha: UIColor {
        return hexString("#481e1c")
    }
    /// 豆汁黄
    var douzhihuang: UIColor {
        return hexString("#f8e8c1")
    }
    /// 垩灰
    var ehui: UIColor {
        return hexString("#737c7b")
    }
    /// 蒽油绿
    var enyoulv: UIColor {
        return hexString("#373834")
    }
    /// 鹅血石红
    var exueshihong: UIColor {
        return hexString("#ab372f")
    }
    /// 鹅掌黄
    var ezhanghuang: UIColor {
        return hexString("#fbb929")
    }

    /// 法螺红
    var faluohong: UIColor {
        return hexString("#ee8055")
    }
    /// 飞泉绿
    var feiquanlv: UIColor {
        return hexString("#497568")
    }
    /// 飞燕草蓝
    var feiyancaolan: UIColor {
        return hexString("#0f59a4")
    }
    /// 粉白
    var fenbai: UIColor {
        return hexString("#fbf2e3")
    }
    /// 风帆黄
    var fengfanhuang: UIColor {
        return hexString("#dc9123")
    }
    /// 凤仙花红
    var fengxianhuahong: UIColor {
        return hexString("#ea7293")
    }
    /// 凤信紫
    var fengxinzi: UIColor {
        return hexString("#c8adc4")
    }
    /// 粉红
    var fenhong: UIColor {
        return hexString("#f2b9b2")
    }
    /// 粉绿
    var fenlv: UIColor {
        return hexString("#83cbac")
    }
    /// 粉团花红
    var fentuanhuahong: UIColor {
        return hexString("#ec9bad")
    }

    /// 佛手黄
    var foshouhuang: UIColor {
        return hexString("#fed71a")
    }
    /// 覆盆子红
    var fupenzihong: UIColor {
        return hexString("#ac1f18")
    }
    /// 芙蓉红
    var furonghong: UIColor {
        return hexString("#f9723d")
    }
    /// 甘草黄
    var gancaohuang: UIColor {
        return hexString("#f3bf4c")
    }
    /// 钢蓝
    var ganglan: UIColor {
        return hexString("#0f1423")
    }
    /// 钢青
    var gangqing: UIColor {
        return hexString("#142334")
    }
    /// 绀红
    var ganhong: UIColor {
        return hexString("#a6522c")
    }
    /// 橄榄黄绿
    var ganlanhuanglv: UIColor {
        return hexString("#bec936")
    }
    /// 橄榄灰
    var ganlanhui: UIColor {
        return hexString("#503e2a")
    }
    /// 橄榄绿
    var ganlanlv: UIColor {
        return hexString("#5e5314")
    }

    /// 苷蓝绿
    var ganlanlv_2: UIColor {
        return hexString("#1f2623")
    }
    /// 橄榄石绿
    var ganlanshilv: UIColor {
        return hexString("#b2cf87")
    }
    /// 绀紫
    var ganzi: UIColor {
        return hexString("#461629")
    }
    /// 葛巾紫
    var gejinzi: UIColor {
        return hexString("#7e2065")
    }
    /// 鸽蓝
    var gelan: UIColor {
        return hexString("#1c2938")
    }
    /// 宫殿绿
    var gongdianlv: UIColor {
        return hexString("#20894d")
    }
    /// 枸枢红
    var goushuhong: UIColor {
        return hexString("#ed3333")
    }
    /// 瓜瓤粉
    var guarangfen: UIColor {
        return hexString("#f9cb8b")
    }
    /// 瓜瓤红
    var guaranghong: UIColor {
        return hexString("#f68c60")
    }
    /// 古鼎灰
    var gudinghui: UIColor {
        return hexString("#36292f")
    }

    /// 谷黄
    var guhuang: UIColor {
        return hexString("#e8b004")
    }
    /// 龟背黄
    var guibeihuang: UIColor {
        return hexString("#826b48")
    }
    /// 桂红
    var guihong: UIColor {
        return hexString("#f25a47")
    }
    /// 桂皮淡棕
    var guipidanzong: UIColor {
        return hexString("#c09351")
    }
    /// 鲑鱼红
    var guiyuhong: UIColor {
        return hexString("#f09c5a")
    }
    /// 钴蓝
    var gulan: UIColor {
        return hexString("#1a94bc")
    }
    /// 谷鞘红
    var guqiaohong: UIColor {
        return hexString("#f17666")
    }
    /// 古铜褐
    var gutonghe: UIColor {
        return hexString("#5c3719")
    }
    /// 古铜绿
    var gutonglv: UIColor {
        return hexString("#533c1b")
    }
    /// 古铜紫
    var gutongzi: UIColor {
        return hexString("#440e25")
    }

    /// 海报灰
    var haibaohui: UIColor {
        return hexString("#483332")
    }
    /// 海军蓝
    var haijunlan: UIColor {
        return hexString("#346c9c")
    }
    /// 海螺橙
    var hailuocheng: UIColor {
        return hexString("#f0945d")
    }
    /// 海沬绿
    var haimeilv: UIColor {
        return hexString("#e2e7bf")
    }
    /// 海鸥灰
    var haiouhui: UIColor {
        return hexString("#9a8878")
    }
    /// 海青
    var haiqing: UIColor {
        return hexString("#22a2c3")
    }
    /// 海参灰
    var haishenhui: UIColor {
        return hexString("#fffefa")
    }
    /// 海涛蓝
    var haitaolan: UIColor {
        return hexString("#15559a")
    }
    /// 海天蓝
    var haitianlan: UIColor {
        return hexString("#c6e6e8")
    }
    /// 海王绿
    var haiwanglv: UIColor {
        return hexString("#248067")
    }

    /// 海象紫
    var haixiangzi: UIColor {
        return hexString("#4b1e2f")
    }
    /// 汉白玉
    var hanbaiyu: UIColor {
        return hexString("#f8f4ed")
    }
    /// 蒿黄
    var haohuang: UIColor {
        return hexString("#dfc243")
    }
    /// 鹤顶红
    var hedinghong: UIColor {
        return hexString("#d42517")
    }
    /// 荷花白
    var hehuabai: UIColor {
        return hexString("#fbecde")
    }
    /// 鹤灰
    var hehui: UIColor {
        return hexString("#4a4035")
    }
    /// 河豚灰
    var hetunhui: UIColor {
        return hexString("#393733")
    }
    /// 荷叶绿
    var heyelv: UIColor {
        return hexString("#1a6840")
    }
    /// 红汞红
    var honggonghong: UIColor {
        return hexString("#f23e23")
    }
    /// 虹蓝
    var honglan: UIColor {
        return hexString("#2177b8")
    }

    /// 猴毛灰
    var houmaohui: UIColor {
        return hexString("#97846c")
    }
    /// 槐花黄绿
    var huaihuahuanglv: UIColor {
        return hexString("#d2d97a")
    }
    /// 黄昏灰
    var huanghunhui: UIColor {
        return hexString("#474b4c")
    }
    /// 黄连黄
    var huanglianhuang: UIColor {
        return hexString("#fcc515")
    }
    /// 花青
    var huaqing: UIColor {
        return hexString("#2376b7")
    }
    /// 灰蓝
    var huilan: UIColor {
        return hexString("#21373d")
    }
    /// 灰绿
    var huilv: UIColor {
        return hexString("#8a6913")
    }
    /// 槲寄生绿
    var hujishenglv: UIColor {
        return hexString("#2b312c")
    }
    /// 火鹅紫
    var huoezi: UIColor {
        return hexString("#33141e")
    }
    /// 火泥棕
    var huonizong: UIColor {
        return hexString("#aa6a4c")
    }

    /// 火山棕
    var huoshanzong: UIColor {
        return hexString("#482522")
    }
    /// 火岩棕
    var huoyanzong: UIColor {
        return hexString("#863020")
    }
    /// 火砖红
    var huozhuanhong: UIColor {
        return hexString("#cd6227")
    }
    /// 虎皮黄
    var hupihuang: UIColor {
        return hexString("#eaad1a")
    }
    /// 琥珀黄
    var hupohuang: UIColor {
        return hexString("#feba07")
    }
    /// 湖水蓝
    var hushuilan: UIColor {
        return hexString("#b0d5df")
    }
    /// 颊红
    var jiahong: UIColor {
        return hexString("#eeaa9c")
    }
    /// 嘉陵水绿
    var jialingshuilv: UIColor {
        return hexString("#add5a2")
    }
    /// 剑锋紫
    var jianfengzi: UIColor {
        return hexString("#3e3841")
    }
    /// 豇豆红
    var jiangdouhong: UIColor {
        return hexString("#ed9db2")
    }

    /// 姜红
    var jianghong: UIColor {
        return hexString("#eeb8c3")
    }
    /// 姜黄
    var jianghuang: UIColor {
        return hexString("#e2c027")
    }
    /// 酱棕
    var jiangzong: UIColor {
        return hexString("#5a1f1b")
    }
    /// 樫鸟蓝
    var jianniaolan: UIColor {
        return hexString("#1491a8")
    }
    /// 涧石蓝
    var jianshilan: UIColor {
        return hexString("#66a9c9")
    }
    /// 焦茶绿
    var jiaochalv: UIColor {
        return hexString("#553b18")
    }
    /// 鲛青
    var jiaoqing: UIColor {
        return hexString("#87723e")
    }
    /// 夹竹桃红
    var jiazhutaohong: UIColor {
        return hexString("#eb507e")
    }
    /// 鸡蛋黄
    var jidanhuang: UIColor {
        return hexString("#fbb612")
    }
    /// 桔梗紫
    var jiegengzi: UIColor {
        return hexString("#813c85")
    }

    /// 芥黄
    var jiehuang: UIColor {
        return hexString("#d9a40e")
    }
    /// 芥花紫
    var jiehuazi: UIColor {
        return hexString("#983680")
    }
    /// 介壳淡粉红
    var jieqiaodanfenhong: UIColor {
        return hexString("#f7cfba")
    }
    /// 蓟粉红
    var jifenhong: UIColor {
        return hexString("#e6d2d5")
    }
    /// 极光红
    var jiguanghong: UIColor {
        return hexString("#f33b1f")
    }
    /// 晶红
    var jinghong: UIColor {
        return hexString("#eea6b7")
    }
    /// 睛蓝
    var jinglan: UIColor {
        return hexString("#5698c3")
    }
    /// 晶石紫
    var jingshizi: UIColor {
        return hexString("#1f2040")
    }
    /// 景泰蓝
    var jingtailan: UIColor {
        return hexString("#2775b6")
    }
    /// 井天蓝
    var jingtianlan: UIColor {
        return hexString("#c3d7df")
    }

    /// 金瓜黄
    var jinguahuang: UIColor {
        return hexString("#fcd217")
    }
    /// 鲸鱼灰
    var jingyuhui: UIColor {
        return hexString("#475164")
    }
    /// 金黄
    var jinhuang: UIColor {
        return hexString("#f26b1f")
    }
    /// 锦葵红
    var jinkuihong: UIColor {
        return hexString("#bf3553")
    }
    /// 金莲花橙
    var jinlianhuacheng: UIColor {
        return hexString("#f86b1d")
    }
    /// 金驼
    var jintuo: UIColor {
        return hexString("#e46828")
    }
    /// 金叶黄
    var jinyehuang: UIColor {
        return hexString("#ffa60f")
    }
    /// 金莺黄
    var jinyinghuang: UIColor {
        return hexString("#f4a83a")
    }
    /// 金盏黄
    var jinzhanhuang: UIColor {
        return hexString("#fcc307")
    }
    /// 槿紫
    var jinzi: UIColor {
        return hexString("#806d9e")
    }

    /// 霁青
    var jiqing: UIColor {
        return hexString("#63bbd0")
    }
    /// 麂棕
    var jizong: UIColor {
        return hexString("#de7622")
    }
    /// 橘橙
    var jucheng: UIColor {
        return hexString("#f97d1c")
    }
    /// 菊蕾白
    var juleibai: UIColor {
        return hexString("#e9ddb6")
    }
    /// 咖啡
    var kafei: UIColor {
        return hexString("#753117")
    }
    /// 可可棕
    var kekezong: UIColor {
        return hexString("#652b1c")
    }
    /// 孔雀蓝
    var kongquelan: UIColor {
        return hexString("#0eb0c9")
    }
    /// 孔雀绿
    var kongquelv: UIColor {
        return hexString("#229453")
    }
    /// 蔻梢绿
    var koushaolv: UIColor {
        return hexString("#5dbe8a")
    }
    /// 葵扇黄
    var kuishanhuang: UIColor {
        return hexString("#f8d86a")
    }

    /// 枯绿
    var kulv: UIColor {
        return hexString("#b78d12")
    }
    /// 莱阳梨黄
    var laiyanglihuang: UIColor {
        return hexString("#815f25")
    }
    /// 浪花绿
    var langhualv: UIColor {
        return hexString("#92b3a5")
    }
    /// 狼烟灰
    var langyanhui: UIColor {
        return hexString("#5d655f")
    }
    /// 蓝绿
    var lanlv: UIColor {
        return hexString("#12a182")
    }
    /// 酪黄
    var laohuang: UIColor {
        return hexString("#f6dead")
    }
    /// 莲瓣红
    var lianbanhong: UIColor {
        return hexString("#ea517f")
    }
    /// 莲子白
    var lianzibai: UIColor {
        return hexString("#e5d3aa")
    }
    /// 丽春红
    var lichunhong: UIColor {
        return hexString("#eb261a")
    }
    /// 菱锰红
    var lingmenghong: UIColor {
        return hexString("#d276a3")
    }

    /// 荔肉白
    var liroubai: UIColor {
        return hexString("#f2e6ce")
    }
    /// 榴萼黄
    var liuehuang: UIColor {
        return hexString("#f9a633")
    }
    /// 榴花红
    var liuhuahong: UIColor {
        return hexString("#f34718")
    }
    /// 硫华黄
    var liuhuahuang: UIColor {
        return hexString("#f2ce2b")
    }
    /// 榴子红
    var liuzihong: UIColor {
        return hexString("#f1908c")
    }
    /// 栗棕
    var lizong: UIColor {
        return hexString("#5c1e19")
    }
    /// 龙睛鱼红
    var longjingyuhong: UIColor {
        return hexString("#ef632b")
    }
    /// 龙睛鱼紫
    var longjingyuzi: UIColor {
        return hexString("#4e2a40")
    }
    /// 龙葵紫
    var longkuizi: UIColor {
        return hexString("#322f3b")
    }
    /// 龙须红
    var longxuhong: UIColor {
        return hexString("#cc5595")
    }

    /// 卵石紫
    var luanshizi: UIColor {
        return hexString("#30161c")
    }
    /// 芦灰
    var luhui: UIColor {
        return hexString("#856d72")
    }
    /// 鹿角棕
    var lujiaozong: UIColor {
        return hexString("#e3bd8d")
    }
    /// 萝卜红
    var luobohong: UIColor {
        return hexString("#f13c22")
    }
    /// 螺甸紫
    var luodianzi: UIColor {
        return hexString("#74759b")
    }
    /// 萝兰紫
    var luolanzi: UIColor {
        return hexString("#c08eaf")
    }
    /// 落霞红
    var luoxiahong: UIColor {
        return hexString("#cf4813")
    }
    /// 落英淡粉
    var luoyingdanfen: UIColor {
        return hexString("#f9e8d0")
    }
    /// 鹿皮褐
    var lupihe: UIColor {
        return hexString("#d99156")
    }
    /// 芦穗灰
    var lusuihui: UIColor {
        return hexString("#bdaead")
    }

    /// 芦苇绿
    var luweilv: UIColor {
        return hexString("#b7d07a")
    }
    /// 绿灰
    var lvhui: UIColor {
        return hexString("#314a43")
    }
    /// 马鞭草紫
    var mabiancaozi: UIColor {
        return hexString("#ede3e7")
    }
    /// 麦秆黄
    var maiganhuang: UIColor {
        return hexString("#f8df70")
    }
    /// 麦苗绿
    var maimiaolv: UIColor {
        return hexString("#55bb8a")
    }
    /// 麦芽糖黄
    var maiyatanghuang: UIColor {
        return hexString("#f9d27d")
    }
    /// 玛瑙灰
    var manaohui: UIColor {
        return hexString("#cfccc9")
    }
    /// 莽丛绿
    var mangconglv: UIColor {
        return hexString("#141e1b")
    }
    /// 芒果黄
    var mangguohuang: UIColor {
        return hexString("#ddc871")
    }
    /// 芒果棕
    var mangguozong: UIColor {
        return hexString("#954416")
    }

    /// 满天星紫
    var mantianxingzi: UIColor {
        return hexString("#2e317c")
    }
    /// 毛绿
    var maolv: UIColor {
        return hexString("#66c18c")
    }
    /// 美蝶绿
    var meidielv: UIColor {
        return hexString("#12aa9c")
    }
    /// 玫瑰粉
    var meiguifen: UIColor {
        return hexString("#f8b37f")
    }
    /// 玫瑰红
    var meiguihong: UIColor {
        return hexString("#d2357d")
    }
    /// 玫瑰灰
    var meiguihui: UIColor {
        return hexString("#4b2e2b")
    }
    /// 玫瑰紫
    var meiguizi: UIColor {
        return hexString("#ba2f7b")
    }
    /// 莓酱红
    var meijianghong: UIColor {
        return hexString("#fa5d19")
    }
    /// 美人焦橙
    var meirenjiaocheng: UIColor {
        return hexString("#fa7e23")
    }
    /// 篾黄
    var miehuang: UIColor {
        return hexString("#f7de98")
    }

    /// 蜜黄
    var mihuang: UIColor {
        return hexString("#fbb957")
    }
    /// 明灰
    var minghui: UIColor {
        return hexString("#8a988e")
    }
    /// 明绿
    var minglv: UIColor {
        return hexString("#9eccab")
    }
    /// 米色
    var mise: UIColor {
        return hexString("#f9e9cd")
    }
    /// 茉莉黄
    var molihuang: UIColor {
        return hexString("#f8df72")
    }
    /// 磨石紫
    var moshizi: UIColor {
        return hexString("#382129")
    }
    /// 墨紫
    var mozi: UIColor {
        return hexString("#310f1b")
    }
    /// 木瓜黄
    var muguahuang: UIColor {
        return hexString("#f9c116")
    }
    /// 暮云灰
    var muyunhui: UIColor {
        return hexString("#4f383e")
    }
    /// 嫩灰
    var nenhui: UIColor {
        return hexString("#74787a")
    }

    /// 嫩菊绿
    var nenjulv: UIColor {
        return hexString("#f0f5e5")
    }
    /// 嫩菱红
    var nenlinghong: UIColor {
        return hexString("#de3f7c")
    }
    /// 镍灰
    var niehui: UIColor {
        return hexString("#9fa39a")
    }
    /// 尼罗蓝
    var niluolan: UIColor {
        return hexString("#2474b5")
    }
    /// 柠檬黄
    var ningmenghuang: UIColor {
        return hexString("#fcd337")
    }
    /// 牛角灰
    var niujiaohui: UIColor {
        return hexString("#2d2e36")
    }
    /// 藕荷
    var ouhe: UIColor {
        return hexString("#edc3ae")
    }
    /// 鸥蓝
    var oulan: UIColor {
        return hexString("#c7d2d4")
    }
    /// 苹果红
    var pingguohong: UIColor {
        return hexString("#f15642")
    }
    /// 苹果绿
    var pingguolv: UIColor {
        return hexString("#bacf65")
    }

    /// 品红
    var pinhong: UIColor {
        return hexString("#ef3473")
    }
    /// 品蓝
    var pinlan: UIColor {
        return hexString("#2b73af")
    }
    /// 枇杷黄
    var pipahuang: UIColor {
        return hexString("#fca106")
    }
    /// 瀑布蓝
    var pubulan: UIColor {
        return hexString("#51c4d3")
    }
    /// 葡萄酒红
    var putaojiuhong: UIColor {
        return hexString("#62102e")
    }
    /// 浅灰
    var qianhui: UIColor {
        return hexString("#dad4cb")
    }
    /// 铅灰
    var qianhui_2: UIColor {
        return hexString("#bbb5ac")
    }
    /// 浅烙黄
    var qianlaohuang: UIColor {
        return hexString("#f9bd10")
    }
    /// 牵牛花蓝
    var qianniuhualan: UIColor {
        return hexString("#1177b0")
    }
    /// 牵牛紫
    var qianniuzi: UIColor {
        return hexString("#681752")
    }

    /// 芡食白
    var qianshibai: UIColor {
        return hexString("#e2e1e4")
    }
    /// 浅驼色
    var qiantuose: UIColor {
        return hexString("#e2c17c")
    }
    /// 茄皮紫
    var qiepizi: UIColor {
        return hexString("#2d0c13")
    }
    /// 青矾绿
    var qingfanlv: UIColor {
        return hexString("#2c9678")
    }
    /// 青蛤壳紫
    var qinghakezi: UIColor {
        return hexString("#bc84a8")
    }
    /// 青灰
    var qinghui: UIColor {
        return hexString("#2b333e")
    }
    /// 青莲
    var qinglian: UIColor {
        return hexString("#8b2671")
    }
    /// 晴山蓝
    var qingshanlan: UIColor {
        return hexString("#8fb2c9")
    }
    /// 清水蓝
    var qingshuilan: UIColor {
        return hexString("#93d5dc")
    }
    /// 蜻蜓红
    var qingtinghong: UIColor {
        return hexString("#f1441d")
    }

    /// 蜻蜓蓝
    var qingtinglan: UIColor {
        return hexString("#3b818c")
    }
    /// 穹灰
    var qionghui: UIColor {
        return hexString("#c4d7d6")
    }
    /// 秋波蓝
    var qiubolan: UIColor {
        return hexString("#8abcd1")
    }
    /// 秋海棠红
    var qiuhaitanghong: UIColor {
        return hexString("#ec2b24")
    }
    /// 秋葵黄
    var qiukuihuang: UIColor {
        return hexString("#eed045")
    }
    /// 曲红
    var quhong: UIColor {
        return hexString("#f05a46")
    }
    /// 群青
    var qunqing: UIColor {
        return hexString("#1772b4")
    }
    /// 肉色
    var rouse: UIColor {
        return hexString("#f7c173")
    }
    /// 软木黄
    var ruanmuhuang: UIColor {
        return hexString("#de9e44")
    }
    /// 乳白
    var rubai: UIColor {
        return hexString("#f9f4dc")
    }

    /// 润红
    var runhong: UIColor {
        return hexString("#f7cdbc")
    }
    /// 乳鸭黄
    var ruyahuang: UIColor {
        return hexString("#ffc90c")
    }
    /// 山梗紫
    var shangengzi: UIColor {
        return hexString("#61649f")
    }
    /// 珊瑚红
    var shanhuhong: UIColor {
        return hexString("#f04a3a")
    }
    /// 山鸡褐
    var shanjihe: UIColor {
        return hexString("#986524")
    }
    /// 山鸡黄
    var shanjihuang: UIColor {
        return hexString("#b78b26")
    }
    /// 闪蓝
    var shanlan: UIColor {
        return hexString("#7cabb1")
    }
    /// 芍药耕红
    var shaoyaogenghong: UIColor {
        return hexString("#eba0b3")
    }
    /// 沙石黄
    var shashihuang: UIColor {
        return hexString("#e5b751")
    }
    /// 沙鱼灰
    var shayuhui: UIColor {
        return hexString("#35333c")
    }

    /// 舌红
    var shehong: UIColor {
        return hexString("#f19790")
    }
    /// 深海绿
    var shenhailv: UIColor {
        return hexString("#1a3b32")
    }
    /// 深灰
    var shenhui: UIColor {
        return hexString("#81776e")
    }
    /// 深灰蓝
    var shenhuilan: UIColor {
        return hexString("#132c33")
    }
    /// 深牵牛紫
    var shenqianniuzi: UIColor {
        return hexString("#1c0d1a")
    }
    /// 石板灰
    var shibanhui: UIColor {
        return hexString("#624941")
    }
    /// 柿红
    var shihong: UIColor {
        return hexString("#f2481b")
    }
    /// 石绿
    var shilv: UIColor {
        return hexString("#57c3c2")
    }
    /// 石蕊红
    var shiruihong: UIColor {
        return hexString("#f0c9cf")
    }
    /// 石竹紫
    var shizhuzi: UIColor {
        return hexString("#63071c")
    }

    /// 水红
    var shuihong: UIColor {
        return hexString("#f1c4cd")
    }
    /// 水绿
    var shuilv: UIColor {
        return hexString("#8cc269")
    }
    /// 水牛灰
    var shuiniuhui: UIColor {
        return hexString("#2f2f35")
    }
    /// 松霜绿
    var songshuanglv: UIColor {
        return hexString("#83a78d")
    }
    /// 松鼠灰
    var songshuhui: UIColor {
        return hexString("#4f4032")
    }
    /// 松叶牡丹红
    var songyemudanhong: UIColor {
        return hexString("#eb3c70")
    }
    /// 筍皮棕
    var sunpizong: UIColor {
        return hexString("#732e12")
    }
    /// 素馨黄
    var suxinhuang: UIColor {
        return hexString("#fccb16")
    }
    /// 苔绿
    var tailv: UIColor {
        return hexString("#887322")
    }
    /// 搪磁蓝
    var tangcilan: UIColor {
        return hexString("#11659a")
    }

    /// 潭水绿
    var tanshuilv: UIColor {
        return hexString("#645822")
    }
    /// 檀紫
    var tanzi: UIColor {
        return hexString("#381924")
    }
    /// 陶瓷红
    var taocihong: UIColor {
        return hexString("#e16723")
    }
    /// 桃红
    var taohong: UIColor {
        return hexString("#f0ada0")
    }
    /// 藤黄
    var tenghuang: UIColor {
        return hexString("#ffd111")
    }
    /// 藤萝紫
    var tengluozi: UIColor {
        return hexString("#8076a3")
    }
    /// 天蓝
    var tianlan: UIColor {
        return hexString("#1677b3")
    }
    /// 田螺绿
    var tianluolv: UIColor {
        return hexString("#5e665b")
    }
    /// 田园绿
    var tianyuanlv: UIColor {
        return hexString("#68b88e")
    }
    /// 铁水红
    var tieshuihong: UIColor {
        return hexString("#f5391c")
    }

    /// 铁棕
    var tiezong: UIColor {
        return hexString("#d85916")
    }
    /// 铜绿
    var tonglv: UIColor {
        return hexString("#2bae85")
    }
    /// 土黄
    var tuhuang: UIColor {
        return hexString("#d6a01d")
    }
    /// 驼色
    var tuose: UIColor {
        return hexString("#66462a")
    }
    /// 兔眼红
    var tuyanhong: UIColor {
        return hexString("#ec4e8a")
    }
    /// 瓦罐灰
    var waguanhui: UIColor {
        return hexString("#47484c")
    }
    /// 瓦灰
    var wahui: UIColor {
        return hexString("#867e76")
    }
    /// 蛙绿
    var walv: UIColor {
        return hexString("#45b787")
    }
    /// 晚波蓝
    var wanbolan: UIColor {
        return hexString("#648e93")
    }
    /// 万寿菊黄
    var wanshoujuhuang: UIColor {
        return hexString("#fb8b05")
    }

    /// 瓦松绿
    var wasonglv: UIColor {
        return hexString("#6e8b74")
    }
    /// 蔚蓝
    var weilan: UIColor {
        return hexString("#29b7cb")
    }
    /// 魏紫
    var weizi: UIColor {
        return hexString("#7e1671")
    }
    /// 榲桲红
    var wenpohong: UIColor {
        return hexString("#ed2f6a")
    }
    /// 无花果红
    var wuhuaguohong: UIColor {
        return hexString("#efafad")
    }
    /// 乌梅紫
    var wumeizi: UIColor {
        return hexString("#1e131d")
    }
    /// 梧枝绿
    var wuzhilv: UIColor {
        return hexString("#69a794")
    }
    /// 霞光红
    var xiaguanghong: UIColor {
        return hexString("#ef82a0")
    }
    /// 虾壳青
    var xiakeqing: UIColor {
        return hexString("#869d9d")
    }
    /// 苋菜紫
    var xiancaizi: UIColor {
        return hexString("#9b1e64")
    }

    /// 香蕉黄
    var xiangjiaohuang: UIColor {
        return hexString("#e4bf11")
    }
    /// 向日葵黄
    var xiangrikuihuang: UIColor {
        return hexString("#fecc11")
    }
    /// 香水玫瑰黄
    var xiangshuimeiguihuang: UIColor {
        return hexString("#f7da94")
    }
    /// 橡树棕
    var xiangshuzong: UIColor {
        return hexString("#773d31")
    }
    /// 象牙白
    var xiangyabai: UIColor {
        return hexString("#fffef8")
    }
    /// 象牙黄
    var xiangyahuang: UIColor {
        return hexString("#f0d695")
    }
    /// 鲜绿
    var xianlv: UIColor {
        return hexString("#43b244")
    }
    /// 晓灰
    var xiaohui: UIColor {
        return hexString("#d4c4b7")
    }
    /// 夏云灰
    var xiayunhui: UIColor {
        return hexString("#617172")
    }
    /// 喜蛋红
    var xidanhong: UIColor {
        return hexString("#ec2c64")
    }

    /// 蟹壳红
    var xiekehong: UIColor {
        return hexString("#f27635")
    }
    /// 蟹壳灰
    var xiekehui: UIColor {
        return hexString("#695e45")
    }
    /// 蟹壳绿
    var xiekelv: UIColor {
        return hexString("#513c20")
    }
    /// 蟹蝥红
    var xiemaohong: UIColor {
        return hexString("#b14b28")
    }
    /// 杏黄
    var xinghuang: UIColor {
        return hexString("#f28e16")
    }
    /// 星灰
    var xinghui: UIColor {
        return hexString("#b2bbbe")
    }
    /// 星蓝
    var xinglan: UIColor {
        return hexString("#93b5cf")
    }
    /// 杏仁黄
    var xingrenhuang: UIColor {
        return hexString("#f7e8aa")
    }
    /// 新禾绿
    var xinhelv: UIColor {
        return hexString("#d2b116")
    }
    /// 雄黄
    var xionghuang: UIColor {
        return hexString("#ff9900")
    }

    /// 夕阳红
    var xiyanghong: UIColor {
        return hexString("#de2a18")
    }
    /// 雪白
    var xuebai: UIColor {
        return hexString("#fffef9")
    }
    /// 蕈紫
    var xunzi: UIColor {
        return hexString("#815c94")
    }
    /// 亚丁绿
    var yadinglv: UIColor {
        return hexString("#428675")
    }
    /// 雅梨黄
    var yalihuang: UIColor {
        return hexString("#fbc82f")
    }
    /// 芽绿
    var yalv: UIColor {
        return hexString("#96c24e")
    }
    /// 洋葱紫
    var yangcongzi: UIColor {
        return hexString("#a8456b")
    }
    /// 洋水仙红
    var yangshuixianhong: UIColor {
        return hexString("#f4c7ba")
    }
    /// 燕颔红
    var yanhanhong: UIColor {
        return hexString("#fc6315")
    }
    /// 燕颔蓝
    var yanhanlan: UIColor {
        return hexString("#131824")
    }

    /// 雁灰
    var yanhui: UIColor {
        return hexString("#80766e")
    }
    /// 鷃蓝
    var yanlan: UIColor {
        return hexString("#144a74")
    }
    /// 岩石棕
    var yanshizong: UIColor {
        return hexString("#964d22")
    }
    /// 燕羽灰
    var yanyuhui: UIColor {
        return hexString("#685e48")
    }
    /// 胭脂红
    var yanzhihong: UIColor {
        return hexString("#f03f24")
    }
    /// 鹞冠紫
    var yaoguanzi: UIColor {
        return hexString("#621d34")
    }
    /// 姚黄
    var yaohuang: UIColor {
        return hexString("#d0deaa")
    }
    /// 夜灰
    var yehui: UIColor {
        return hexString("#847c74")
    }
    /// 野菊紫
    var yejuzi: UIColor {
        return hexString("#525288")
    }
    /// 椰壳棕
    var yekezong: UIColor {
        return hexString("#883a1e")
    }

    /// 野葡萄紫
    var yeputaozi: UIColor {
        return hexString("#302f4b")
    }
    /// 野蔷薇红
    var yeqiangweihong: UIColor {
        return hexString("#fb9968")
    }
    /// 蜴蜊绿
    var yililv: UIColor {
        return hexString("#835e1d")
    }
    /// 银白
    var yinbai: UIColor {
        return hexString("#f1f0ed")
    }
    /// 樱草紫
    var yingcaozi: UIColor {
        return hexString("#c06f98")
    }
    /// 樱桃红
    var yingtaohong: UIColor {
        return hexString("#ed3321")
    }
    /// 鹦鹉冠黄
    var yingwuguanhuang: UIColor {
        return hexString("#f6c430")
    }
    /// 鹦鹉绿
    var yingwulv: UIColor {
        return hexString("#5bae23")
    }
    /// 隐红灰
    var yinhonghui: UIColor {
        return hexString("#b598a1")
    }
    /// 银灰
    var yinhui: UIColor {
        return hexString("#918072")
    }

    /// 银鼠灰
    var yinshuhui: UIColor {
        return hexString("#b5aa90")
    }
    /// 银鱼白
    var yinyubai: UIColor {
        return hexString("#cdd1d3")
    }
    /// 银朱
    var yinzhu: UIColor {
        return hexString("#f43e06")
    }
    /// 油菜花黄
    var youcaihuahuang: UIColor {
        return hexString("#fbda41")
    }
    /// 鼬黄
    var youhuang: UIColor {
        return hexString("#fcb70a")
    }
    /// 柚黄
    var youhuang_2: UIColor {
        return hexString("#f1ca17")
    }
    /// 釉蓝
    var youlan: UIColor {
        return hexString("#1781b5")
    }
    /// 油绿
    var youlv: UIColor {
        return hexString("#253d24")
    }
    /// 远山紫
    var yuanshanzi: UIColor {
        return hexString("#ccccd6")
    }
    /// 远天蓝
    var yuantianlan: UIColor {
        return hexString("#d0dfe6")
    }

    /// 鸢尾蓝
    var yuanweilan: UIColor {
        return hexString("#158bb8")
    }
    /// 鱼肚白
    var yudubai: UIColor {
        return hexString("#f7f4ed")
    }
    /// 月白
    var yuebai: UIColor {
        return hexString("#eef7f2")
    }
    /// 月灰
    var yuehui: UIColor {
        return hexString("#b7ae8f")
    }
    /// 月影白
    var yueyingbai: UIColor {
        return hexString("#c0c4c3")
    }
    /// 玉粉红
    var yufenhong: UIColor {
        return hexString("#e8b49a")
    }
    /// 余烬红
    var yujinhong: UIColor {
        return hexString("#cf7543")
    }
    /// 云峰白
    var yunfengbai: UIColor {
        return hexString("#d8e3e7")
    }
    /// 云山蓝
    var yunshanlan: UIColor {
        return hexString("#2f90b9")
    }
    /// 云杉绿
    var yunshanlv: UIColor {
        return hexString("#15231b")
    }

    /// 云水蓝
    var yunshuilan: UIColor {
        return hexString("#baccd9")
    }
    /// 玉鈫蓝
    var yuqinlan: UIColor {
        return hexString("#126e82")
    }
    /// 鱼鳃红
    var yusaihong: UIColor {
        return hexString("#ed3b2f")
    }
    /// 羽扇豆蓝
    var yushandoulan: UIColor {
        return hexString("#619ac3")
    }
    /// 玉髓绿
    var yusuilv: UIColor {
        return hexString("#41b349")
    }
    /// 鱼尾灰
    var yuweihui: UIColor {
        return hexString("#5e616d")
    }
    /// 玉簪绿
    var yuzanlv: UIColor {
        return hexString("#a4cab6")
    }
    /// 战舰灰
    var zhanjianhui: UIColor {
        return hexString("#495c69")
    }
    /// 柞叶棕
    var zhayezong: UIColor {
        return hexString("#692a1b")
    }
    /// 珍珠灰
    var zhenzhuhui: UIColor {
        return hexString("#e4dfd7")
    }

    /// 赭石
    var zheshi: UIColor {
        return hexString("#862617")
    }
    /// 芝兰紫
    var zhilanzi: UIColor {
        return hexString("#e9ccd3")
    }
    /// 栀子黄
    var zhizihuang: UIColor {
        return hexString("#ebb10d")
    }
    /// 中红灰
    var zhonghonghui: UIColor {
        return hexString("#8b614d")
    }
    /// 中灰
    var zhonghui: UIColor {
        return hexString("#a49c93")
    }
    /// 中灰驼
    var zhonghuituo: UIColor {
        return hexString("#603d30")
    }
    /// 朱红
    var zhuhong: UIColor {
        return hexString("#ed5126")
    }
    /// 竹篁绿
    var zhuhuanglv: UIColor {
        return hexString("#b9dec9")
    }
    /// 竹绿
    var zhulv: UIColor {
        return hexString("#1ba784")
    }
    /// 珠母灰
    var zhumuhui: UIColor {
        return hexString("#64483d")
    }

    /// 蛛网灰
    var zhuwanghui: UIColor {
        return hexString("#b7a091")
    }
    /// 紫灰
    var zihui: UIColor {
        return hexString("#5d3f51")
    }
    /// 紫荆红
    var zijinghong: UIColor {
        return hexString("#ee2c79")
    }
    /// 芓紫
    var zizi: UIColor {
        return hexString("#894276")
    }
    /// 棕榈绿
    var zonglvlv: UIColor {
        return hexString("#5b4913")
    }
    /// 粽叶绿
    var zongyelv: UIColor {
        return hexString("#876818")
    }
    /// 醉瓜肉
    var zuiguarou: UIColor {
        return hexString("#db8540")
    }
}
