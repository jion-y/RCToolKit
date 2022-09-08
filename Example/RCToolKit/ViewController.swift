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
        self.view.rc.x = 10;
//        queue.async {
            RCLog.logD(message: "As of CocoaLumberjack 3.6.0, you can use the Swift Package Manager as integration method. If you want to use the Swift Package Manager as integration method, either use Xcode to add the package dependency or add the following dependency to your Package.swift:",tag: "HAHAH");
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

