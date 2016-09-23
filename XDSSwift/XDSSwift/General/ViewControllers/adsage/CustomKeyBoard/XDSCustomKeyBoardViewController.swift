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
        
//        let textField = UITextField(frame: CGRect.zero);
//        textField.backgroundColor = UIColor.red;
//        textField.translatesAutoresizingMaskIntoConstraints = false;
//        textField.placeholder = "请输入数字";
//        self.view.addSubview(textField);
//        
//        let keyboard = XDSKeyBoard();
//        keyboard.backgroundColor = UIColor.yellow;
//        textField.inputView = keyboard;
//        
//        
//        let systemTextField = UITextField(frame: CGRect.zero);
//        systemTextField.translatesAutoresizingMaskIntoConstraints = false;
//        systemTextField.placeholder = "系统输入框";
//        systemTextField.backgroundColor = UIColor.red;
//        systemTextField.isSecureTextEntry = true;
//        self.view.addSubview(systemTextField);
//
//        let systemTextField2 = UITextField(frame: CGRect.zero);
//        systemTextField2.translatesAutoresizingMaskIntoConstraints = false;
//        systemTextField2.placeholder = "系统输入框";
//        systemTextField2.backgroundColor = UIColor.red;
//        systemTextField2.isSecureTextEntry = true;
//        self.view.addSubview(systemTextField2);
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.willKeyboardShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil);
//        
//        let viewsDict = ["textField":textField, "systemTextField":systemTextField, "systemTextField2":systemTextField2];
//        
//        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[systemTextField2(==systemTextField)]-100-[systemTextField(==textField)]-100-[textField(==40)]", options: .alignAllCenterX, metrics: nil, views: viewsDict);
//        self.view.addConstraints(constraints);
//
//        self.view.addConstraint(NSLayoutConstraint(item: systemTextField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 300));
//        
//                self.view.addConstraint(NSLayoutConstraint(item: textField, attribute: .width, relatedBy: .equal, toItem: systemTextField, attribute: .width, multiplier: 1.0, constant: 0));
        
//        let constraints1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[systemTextField(==textField)]-20-|", options: .alignAllLeft, metrics: nil, views: viewsDict);
//        self.view.addConstraints(constraints1);
        
        self.createEnglishKeyboardWithAotoLayout();
    }

    
    
    //MARK: 纯英文键盘
    private func createEnglishKeyboardWithAotoLayout(){
        self.navigationController?.navigationBar.isTranslucent = true;
        let button1 = UIButton(frame: CGRect.zero);
        button1.backgroundColor = UIColor.red;
        button1.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(button1);

        let button2 = UIButton(frame: CGRect.zero);
        button1.translatesAutoresizingMaskIntoConstraints = false;

        button2.backgroundColor = UIColor.blue;
        self.view.addSubview(button2);

        let constraint0 = NSLayoutConstraint(item: button1, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 100);
        let constraint1 = NSLayoutConstraint(item: button1, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0);
        let constraint11 = NSLayoutConstraint(item: button1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40);

        
        let constraint2 = NSLayoutConstraint(item: button2, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0);
        let constraint21 = NSLayoutConstraint(item: button2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40);
        
        let xxx = NSLayoutConstraint.constraints(withVisualFormat: "H:[button1(==button2)]-20-[button2(==100)]", options: .alignAllCenterY, metrics: nil, views: ["button1":button1, "button2":button2]);
        self.view.addConstraints(xxx);

        self.view.addConstraints([constraint1, constraint11, constraint2, constraint21]);
        
        
        //创建空格
    }
    
    
    @objc private func willKeyboardShow(notification:Notification){
        let info = notification.userInfo!;
        let kbSize = info[UIKeyboardFrameEndUserInfoKey];
        NSLog("\(kbSize)");
    }

}
