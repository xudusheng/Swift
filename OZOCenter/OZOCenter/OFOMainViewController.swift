//
//  OFOMainViewController.swift
//  OZOCenter
//
//  Created by zhengda on 16/11/16.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class OFOMainViewController: UIViewController {

    @IBOutlet weak var fetchPasswordButton: UIButton!
    @IBOutlet weak var saveNewBikeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainViewControllerDataInit();
        self.createMainViewControllerUI();
    }

    //MARK: - UI相关
    func createMainViewControllerUI(){
        fetchPasswordButton.layer.cornerRadius = 60;
        fetchPasswordButton.layer.masksToBounds = true;

        saveNewBikeButton.layer.cornerRadius = 60;
        saveNewBikeButton.layer.masksToBounds = true;
    }
    
    
    //MARK: - 代理方法
    
    //MARK: - 网络请求
    
    //MARK: - 事件响应处理
    
    @IBAction func fetchPasswordButtonClick(_ sender: UIButton) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let fetchPasswordVC = mainStoryboard.instantiateViewController(withIdentifier: "OFOFecthPasswordViewController");
        self.presentTransparentViewController(fetchPasswordVC);
    }
    
    @IBAction func saveNewBikeButtonClick(_ sender: UIButton) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil);
        let saveNewBikeVC = mainStoryboard.instantiateViewController(withIdentifier: "OFOSaveNewBikeViewController");
        self.presentTransparentViewController(saveNewBikeVC);
    }
    
    //MARK: - 其他私有方法
    private func presentTransparentViewController(_ transparentViewController:UIViewController){
        transparentViewController.view.backgroundColor = UIColor(white: 0, alpha: 0.2);
        transparentViewController.modalTransitionStyle = .crossDissolve;
        let controller = self.view.window?.rootViewController;
        if  (UIDevice.current.systemVersion >= "8.0") {
            transparentViewController.providesPresentationContextTransitionStyle = true;
            transparentViewController.definesPresentationContext = true;
            transparentViewController.modalPresentationStyle = .overCurrentContext;
            controller?.present(transparentViewController, animated: false, completion: nil);
        }else{
            controller?.modalPresentationStyle = .currentContext;
            controller?.present(transparentViewController, animated: false, completion: nil);
            controller?.modalPresentationStyle = .fullScreen;
        }
    }
    
    //MARK: - 内存管理相关
    func mainViewControllerDataInit(){
    }


    
}
