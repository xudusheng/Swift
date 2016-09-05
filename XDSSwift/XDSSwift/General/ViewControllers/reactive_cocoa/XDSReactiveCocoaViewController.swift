//
//  XDSReactiveCocoaViewController.swift
//  XDSSwift
//
//  Created by zhengda on 16/9/2.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit
import ReactiveCocoa

class XDSReactiveCocoaViewController: XDSRootViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.rac_textSignal().map { (value:AnyObject!) -> AnyObject! in
            if !(value is String){
                return 0;
            }
            NSLog("length = \(value.description)");
            let value_new = FromAnyObjectToString(from: value);
            return value_new.length();
            }.filter { (value:AnyObject!) -> Bool in
                let value_new = value as! Int;
                return (value_new > 3) ? true : false;
            }.subscribeNext {(value:AnyObject!) in
                NSLog("value = \(value)");
                "value".length();
        };
    
        RAC(self, "passwordTextField.text").assignSignal(userNameTextField.rac_textSignal());
        self.passwordTextField.isEqual(self);
    }
}
