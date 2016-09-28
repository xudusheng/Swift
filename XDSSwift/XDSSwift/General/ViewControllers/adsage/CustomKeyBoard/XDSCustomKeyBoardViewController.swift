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
        let systemTextField = UITextField(frame: CGRect.zero);
        systemTextField.translatesAutoresizingMaskIntoConstraints = false;
        systemTextField.placeholder = "系统输入框";
        systemTextField.backgroundColor = UIColor.red;
        systemTextField.isSecureTextEntry = true;
        self.view.addSubview(systemTextField);
        
        let englishTextField = UITextField(frame: CGRect.zero);
        englishTextField.backgroundColor = UIColor.red;
        englishTextField.translatesAutoresizingMaskIntoConstraints = false;
        englishTextField.placeholder = "英文键盘";
        self.view.addSubview(englishTextField);
        _ = XDSKeyboard(inputView: englishTextField, type: .english);
        
        let digitTextField = UITextField(frame: CGRect.zero);
        digitTextField.backgroundColor = UIColor.red;
        digitTextField.translatesAutoresizingMaskIntoConstraints = false;
        digitTextField.placeholder = "数字键盘";
        self.view.addSubview(digitTextField);
        _ = XDSKeyboard(inputView: digitTextField, type: .digit);
        
        let signTextField = UITextField(frame: CGRect.zero);
        signTextField.backgroundColor = UIColor.red;
        signTextField.translatesAutoresizingMaskIntoConstraints = false;
        signTextField.placeholder = "符号键盘";
        self.view.addSubview(signTextField);
        _ = XDSKeyboard(inputView: signTextField, type: .sign);
 
        

        NotificationCenter.default.addObserver(self, selector: #selector(self.willKeyboardShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil);
        
        let viewsDict = [ "systemTextField":systemTextField, "englishTextField":englishTextField, "digitTextField":digitTextField, "signTextField":signTextField];
        
        let constraints_v = NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[systemTextField(==40)]-20-[englishTextField(==systemTextField)]-20-[digitTextField(==englishTextField)]-20-[signTextField(==digitTextField)]",
                                                         options: [.alignAllLeft , .alignAllRight],
                                                         metrics: nil,
                                                         views: viewsDict);
        self.view.addConstraints(constraints_v);

        let constraints_h = NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[systemTextField]-40-|",
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
