//
//  OFOFecthPasswordViewController.swift
//  OZOCenter
//
//  Created by zhengda on 16/11/16.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class OFOFecthPasswordViewController: UIViewController {

    @IBOutlet weak var bikeNoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: - UI相关
    func createFecthPasswordViewControllerUI(){
        
    }
    
    //MARK: - 代理方法
    
    //MARK: - 网络请求
    
    //MARK: - 事件响应处理
    @IBAction func closeButtonClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil);
        
    }
    
    @IBAction func commitButtonClick(_ sender: UIButton) {
        if self.isCommitButtonAvailable() {
            let parameters = ["":""];
            let urlString = "https://api.bmob.cn/1/classes/bikes?where={\"bike_num\":\"\(bikeNoTextField.text!)\"}";
            OFORequest.request(httpMethod: HttpMethodType.GET, urlString: urlString, parameters: parameters, result: { (success:Bool, result:AnyObject?) in
                if success {
                    let resultInfo = result as! Dictionary<String, AnyObject>;
                    NSLog("result =\(result!)");
                    let bikeArr = resultInfo["results"];
                    if bikeArr != nil {
                        OperationQueue.main.addOperation({ 
                            let bikes = bikeArr as! Array<Dictionary<String, String>>;
                            if bikes.count > 0 {
                                let bike = bikes[0];
                                let password = bike["bike_pwd"];
                                
                                self.bikeNoTextField.text = "密码：\(password!)";
                                NSLog("password =\(password)");
                            }else{
                                let nonResult = "没有查询到该车密码，请录入";
                                self.bikeNoTextField.text = nonResult;
                            }
                            self.bikeNoTextField.isEnabled = false;
                        })
                    }
                }else{
                    NSLog("请求失败");
                }
            })
        }
    }
    //MARK: - 其他私有方法
    private func isCommitButtonAvailable() -> Bool{
        var message = "";
        if (bikeNoTextField.text?.characters.count)! < 1 {
            message = "请输入车牌号";
        }
        
        if message.characters.count > 1 {
            NSLog(message);
            return false;
        }else{
            return true;
        }

    }
    //MARK: - 内存管理相关
    func fecthPasswordViewControllerDataInit(){
        
    }

}
