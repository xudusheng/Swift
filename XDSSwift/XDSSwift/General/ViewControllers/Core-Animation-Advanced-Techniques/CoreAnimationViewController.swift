//
//  CoreAnimationViewController.swift
//  XDSSwift
//
//  Created by zhengda on 16/7/26.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class CoreAnimationViewController: XDSRootViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.swiftRootTableViewControllerDataInit();
        self.createSwiftRootTableViewControllerUI();
    }

    //MARK: - UI相关
    func createSwiftRootTableViewControllerUI(){
        let layerView = UIView(frame: CGRectMake(0, 0, 200, 200));
        layerView.backgroundColor = UIColor.brownColor();
        layerView.center = self.view.center;
        self.view.addSubview(layerView);
        
//        let snowmanImage:UIImage! = UIImage(named: "snowman");
//        layerView.layer.contents = snowmanImage.CGImage;
//        layerView.layer.contentsGravity = kCAGravityCenter;
//        layerView.layer.contentsScale = snowmanImage.scale;
        
        
        let mapImage = UIImage(named: "map.bmp");
        layerView.layer.contents = mapImage?.CGImage;
        layerView.layer.contentsGravity = kCAGravityResizeAspect;
        layerView.layer.contentsRect = CGRectMake(0.5, 0.5, 0.5, 0.5);
        
    }

    
    
    //MARK: - 代理方法

    //MARK: - 网络请求
    
    //MARK: - 事件响应处理
    
    //MARK: - 其他私有方法
    
    //MARK: - 内存管理相关
    func swiftRootTableViewControllerDataInit(){
        
    }

}
