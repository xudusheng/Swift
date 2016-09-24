//
//  XDSCustomKeyBoardViewController.swift
//  XDSSwift
//
//  Created by zhengda on 16/9/21.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class XDSCustomKeyBoardViewController: XDSRootViewController {
    deinit {
        NSLog("XDSCustomKeyBoardViewController===> deinit")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textField = UITextField(frame: CGRect.zero);
        textField.backgroundColor = UIColor.red;
        textField.translatesAutoresizingMaskIntoConstraints = false;
        textField.placeholder = "请输入数字";
        self.view.addSubview(textField);
        
        let keyboard = XDSEnglishKeyboard();
//        textField.inputView = keyboard;
        keyboard.set(inputView: textField);
        
        
        let systemTextField = UITextField(frame: CGRect.zero);
        systemTextField.translatesAutoresizingMaskIntoConstraints = false;
        systemTextField.placeholder = "系统输入框";
        systemTextField.backgroundColor = UIColor.red;
        systemTextField.isSecureTextEntry = true;
        self.view.addSubview(systemTextField);

        NotificationCenter.default.addObserver(self, selector: #selector(self.willKeyboardShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil);
        
        let viewsDict = ["textField":textField, "systemTextField":systemTextField];
        
        let constraints_v = NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[systemTextField(==textField)]-100-[textField(==40)]",
                                                         options: .alignAllCenterX,
                                                         metrics: nil,
                                                         views: viewsDict);
        self.view.addConstraints(constraints_v);

        
        let constraints_h = NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[systemTextField(==textField)]-40-|",
                                                          options: .alignAllCenterX,
                                                          metrics: nil,
                                                          views: viewsDict);
        self.view.addConstraints(constraints_h);
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    @objc private func willKeyboardShow(notification:Notification){
        let info = notification.userInfo!;
        let kbSize = info[UIKeyboardFrameEndUserInfoKey];
        NSLog("\(kbSize)");
    }

}
