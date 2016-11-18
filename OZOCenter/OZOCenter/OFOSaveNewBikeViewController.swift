//
//  OFOSaveNewBikeViewController.swift
//  OZOCenter
//
//  Created by zhengda on 16/11/16.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class OFOSaveNewBikeViewController: UIViewController {


    @IBOutlet weak var bikeNoTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.saveNewBikeViewControllerDataInit();
        self.createSaveNewBikeViewControllerUI();
    }

    //MARK: - UI相关
    func createSaveNewBikeViewControllerUI(){
    }
    
    //MARK: - 代理方法
    
    //MARK: - 网络请求
    
    //MARK: - 事件响应处理
    
    @IBAction func closeButtonClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil);
    
    }
    
    @IBAction func commitButtonClick(_ sender: UIButton) {
        if self.isCommitButtonAvailable() {
            let password = passwordTextField.text!;
            let bikeNo = bikeNoTextField.text!;
            let para = ["contributoryId":"603bb2d695", "bike_pwd":"\(password)", "bike_num":"\(bikeNo)"];
            NSLog("\(object_getClass(para))");

            let urlString = "https://api.bmob.cn/1/classes/bikes";
            OFORequest.request(httpMethod: HttpMethodType.POST, urlString: urlString, parameters: para, result: { (success:Bool, result:AnyObject?) in
                if success {
//                    let resultInfo = result as! Dictionary<String, AnyObject>;
                    NSLog("result =\(result!)");
                    
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
        }else if((passwordTextField.text?.characters.count)! < 1){
            message = "请输入车密码";
        }
        
        if message.characters.count > 1 {
            NSLog(message);
            return false;
        }else{
            return true;
        }
        
    }
    //MARK: - 内存管理相关
    func saveNewBikeViewControllerDataInit(){
    }


}
