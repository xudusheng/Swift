//
//  XDSCustomKeyBoardViewController.swift
//  XDSSwift
//
//  Created by zhengda on 16/9/21.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class XDSCustomKeyBoardViewController: XDSRootViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: SWIFT_DEVICE_SCREEN_WIDTH - 40, height: 40.0));
        textField.center = self.view.center;
        textField.placeholder = "请输入数字";
        self.view.addSubview(textField);
        
//        let keyboard = XDSKeyBoard(frame: CGRect(x: 0, y: 0, width: SWIFT_DEVICE_SCREEN_WIDTH, height: 200));
        let keyboard = Bundle.main.loadNibNamed("XDSKeyBoard", owner: self, options: nil)?.last as! XDSKeyBoard;
        keyboard.frame = CGRect(x: 0, y: 0, width: SWIFT_DEVICE_SCREEN_WIDTH, height: 200);
        keyboard.backgroundColor = UIColor.yellow;
        textField.inputView = keyboard;
        
        
        let systemTextField = UITextField(frame: CGRect(x: 0, y: 100, width: SWIFT_DEVICE_SCREEN_WIDTH - 40, height: 40.0));
        systemTextField.placeholder = "系统输入框";
        systemTextField.isSecureTextEntry = true;
        self.view.addSubview(systemTextField);

        
    }


}
