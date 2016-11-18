//
//  OFORegisterTableViewController.swift
//  OZOCenter
//
//  Created by zhengda on 16/11/16.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class OFORegisterTableViewController: UITableViewController {

    @IBOutlet weak internal var userTextField: UITextField!
    
    @IBOutlet weak internal var telephoneTextField: UITextField!
    
    @IBOutlet weak internal var passwordTextField: UITextField!

    @IBOutlet weak var invitationCodeTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewControllerDataInit();
        self.createRegisterTableViewControllerUI();
    }

    //MARK: - UI相关
    func createRegisterTableViewControllerUI(){
    }
    
    //MARK: - 代理方法
    
    //MARK: - 网络请求
    
    //MARK: - 事件响应处理
    
    @IBAction func registerButtonClick(_ sender: UIButton) {
        self.view.endEditing(true);
        if (self.isRegisterButtonAvailable()) {
            
        }
    }
    
    @IBAction func goLoginButtonClick(_ sender: UIButton) {
        self.view.endEditing(true);
        self.navigationController?.popViewController(animated: true);
    }
    

    //MARK: - 其他私有方法
    func isRegisterButtonAvailable() -> Bool {
        var message = "";
        if (userTextField.text?.characters.count)! < 1 {
            message = "请输入您的姓名";
        }else if ((telephoneTextField.text?.characters.count)! < 1){
            message = "请输入手机号码";
        }else if ((passwordTextField.text?.characters.count)! < 1){
            message = "请输入登录密码";
        }else if ((invitationCodeTextField.text?.characters.count)! < 1){
            message = "请输入邀请码";
        }
        
        if message.characters.count > 0 {
            NSLog(message);
            return false;
        }else{
            return true;
        }
        
    }
    //MARK: - 内存管理相关
    func registerTableViewControllerDataInit(){
    }

    
}
