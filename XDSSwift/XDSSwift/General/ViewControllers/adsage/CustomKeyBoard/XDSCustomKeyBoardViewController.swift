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
        
        let textField = UITextField(frame: CGRect.zero);
        textField.backgroundColor = UIColor.red;
        textField.placeholder = "请输入数字";
        self.view.addSubview(textField);
        
        let keyboard = XDSKeyBoard();
        keyboard.backgroundColor = UIColor.yellow;
        textField.inputView = keyboard;
        
        
        let systemTextField = UITextField(frame: CGRect.zero);
        systemTextField.placeholder = "系统输入框";
        systemTextField.backgroundColor = UIColor.red;
        systemTextField.isSecureTextEntry = true;
        self.view.addSubview(systemTextField);
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.willKeyboardShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil);
        
        let viewsDict = ["textField":textField, "systemTextField":systemTextField];
        
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[systemTextField(==40)]-100-[textField(==40)]", options: .alignAllCenterX, metrics: nil, views: viewsDict);
        self.view.addConstraints(constraints);

        let constraints1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[systemTextField]-20-|", options: .alignAllLeft, metrics: nil, views: viewsDict);
        self.view.addConstraints(constraints1);
        
        let constraints2 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[textField]-20-|", options: .alignAllLeft, metrics: nil, views: viewsDict);
        self.view.addConstraints(constraints2);

    }

    @objc private func willKeyboardShow(notification:Notification){
        let info = notification.userInfo!;
        let kbSize = info[UIKeyboardFrameEndUserInfoKey];
        NSLog("\(kbSize)");
    }

}
