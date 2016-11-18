//
//  OFOLoginViewController.swift
//  OZOCenter
//
//  Created by zhengda on 16/11/16.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class OFOLoginViewController: UITableViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var session = URLSession(configuration: URLSessionConfiguration.ephemeral);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginViewControllerDataInit();
        self.createLoginViewControllerUI();
    }

    //MARK: - UI相关
    func createLoginViewControllerUI(){
    }
    
    //MARK: - 代理方法
    
    //MARK: - 网络请求
    
    //MARK: - 事件响应处理
    @IBAction func loginButtonClick(_ sender: UIButton) {
        self.view.endEditing(true);
        if (self.isLoginButtonAvailable()) {
            let parameters = ["":""];
            
            let urlString = "https://api.bmob.cn/1/login?username=\(userTextField.text!)&password=\(passwordTextField.text!)";
            OFORequest.request(httpMethod: HttpMethodType.GET, urlString: urlString, parameters: parameters, result: { (success:Bool, result:AnyObject?) in
                if success {
                    NSLog("result =\(result)");
                }else{
                    NSLog("请求失败");
                }
            })
        }
    }
    @IBAction func goRegisterButtonClick(_ sender: UIButton) {
        self.view.endEditing(true);
        
        let parameters = ["":""];
        let urlString = "https://api.bmob.cn/1/classes/RegisterNum";
        OFORequest.request(httpMethod: HttpMethodType.GET, urlString: urlString, parameters: parameters, result: { (success:Bool, result:AnyObject?) in
            if success {
                NSLog("result =\(result)");
            }else{
                NSLog("请求失败");
            }
        })
    }
    
    //MARK: - 其他私有方法
    func isLoginButtonAvailable() -> Bool {
        var message = "";
        if (userTextField.text?.characters.count)! < 1 {
            message = "请输入您的姓名";
        }else if ((passwordTextField.text?.characters.count)! < 1){
            message = "请输入登录密码";
        }
        
        if message.characters.count > 0 {
            NSLog(message);
            return false;
        }else{
            return true;
        }
        
    }
    //MARK: - 内存管理相关
    func loginViewControllerDataInit(){
    }


}
