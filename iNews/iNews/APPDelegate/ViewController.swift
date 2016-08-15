//
//  ViewController.swift
//  iNews
//
//  Created by zhengda on 16/8/15.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad();
        
        INSRequestHelper.fetchHomePage(1, page: 1);
    }

    //MARK: - UI相关
    func createSwiftRootTableViewControllerUI(){
        
    }
    
    //MARK: - 代理方法
    
    //MARK: - 网络请求
    
    //MARK: - 事件响应处理
    
    //MARK: - 其他私有方法
    
    //MARK: - 内存管理相关
    func swiftRootTableViewControllerDataInit(){
    }

    
}

