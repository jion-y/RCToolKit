//
//  ViewController.swift
//  RCToolKit
//
//  Created by liuming on 09/07/2022.
//  Copyright (c) 2022 liuming. All rights reserved.
//

import UIKit
import RCToolKit
class ViewController: UIViewController {
    private let queue =  DispatchQueue(label: "com.hello.kit")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        RCLog.addLogger(logger: RCConsoleLog())
        RCLog.addLogger(logger:RCFileLog())
        self.view.rc.x = 10;
//        queue.async {
            RCLog.logD(message: "走你！！！！");
        RCLog.LogT(tag: "xxx1");
        sleep(10)
        RCLog.LogT(tag: "xxx1");
        RCLog.LogT(tag: "xxx1")
        RCLog.removeLogT(tag: "xxx1");
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

