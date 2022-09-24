//
//  ViewController.swift
//  RCToolKit
//
//  Created by liuming on 09/07/2022.
//  Copyright (c) 2022 liuming. All rights reserved.
//

import RCToolKit
import UIKit
class ViewController: UIViewController {
    private let queue = DispatchQueue(label: "com.hello.kit")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        RCLog.rc.setLogLevel(level: .debug)
        RCLog.rc.addLogger(logger: RCConsoleLog())
        RCLog.rc.addLogger(logger: RCFileLog())
        if #available(iOS 13.0, *) {
            RCLog.rc.addLogger(logger: RCWebsocketLog())
        } else {
            // Fallback on earlier versions
        }
        self.view.rc.x = 10.aptValue
//        queue.async {
        RCLog.rc.logD(message: "走你！！！！")
        RCLog.rc.LogT(tag: "xxx1")
//        sleep(2)åß
        RCLog.rc.LogT(tag: "xxx1")
        RCLog.rc.LogT(tag: "xxx1")
        RCLog.rc.removeLogT(tag: "xxx1")
//        for i in 0..<1000 {
//            RCLog.rc.logD(message: "this message index \(i)");
//        }

        self.view.rc.bgColor(.white).clipsToBounds()

        UIImageView().rc.addToSuperView(self.view)
                        .bgColor(.blue)
                        .frame(CGRect(x: 10, y: 10, width: 100, height: 100))
                        .bgColor(.blue)
                        .image(nil)
                        .cornerRadius(20.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
