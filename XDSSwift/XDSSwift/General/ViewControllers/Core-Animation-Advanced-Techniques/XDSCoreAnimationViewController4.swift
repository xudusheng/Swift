//
//  XDSCoreAnimationViewController4.swift
//  XDSSwift
//
//  Created by zhengda on 16/8/1.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit
/// 隐式动画和显式动画

class XDSCoreAnimationViewController4: XDSRootViewController {
    var containerView : UIView!;
    var colorLayer : CALayer!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.coreAnimationViewController4DataInit();
        self.createCoreAnimationViewController4UI();
        
    }

    //MARK: - UI相关
    func createCoreAnimationViewController4UI(){
        self.createChangeColorLayer();
    }
    
    //TODO:随机改变图层颜色
    func createChangeColorLayer() -> Void {
        containerView = UIView(frame: CGRectMake(0, 0, 300, 300));
        containerView.center = self.view.center;
        containerView?.backgroundColor = UIColor(white: 0, alpha: 0.3);
        self.view.addSubview(containerView!);
        
        //create sublayer
        colorLayer = CALayer();
        colorLayer.frame = CGRectMake(0, 0, 150.0, 150.0);
        colorLayer.position = CGPointMake(CGRectGetWidth(containerView.frame)/2, CGRectGetHeight(containerView.frame)/2);
        self.colorLayer.backgroundColor = UIColor.blueColor().CGColor;
        //add it to our view
        containerView?.layer.addSublayer(colorLayer!);
        
        let button = UIButton(type: .RoundedRect);
        button.setTitle("Change Color", forState: .Normal);
        button.addTarget(self, action: #selector(XDSCoreAnimationViewController4.changeColor), forControlEvents: .TouchUpInside);
        containerView.addSubview(button);
        button.snp_makeConstraints { (make) in
            make.centerX.equalTo(containerView.snp_centerX);
            make.bottom.equalTo(-20);
            make.height.equalTo(35);
            make.width.equalTo(100);
        };
        
    }
    
    //MARK: - 代理方法
    
    //MARK: - 网络请求
    
    //MARK: - 事件响应处理
    @objc func changeColor(){
        //randomize the layer background color
        CATransaction.begin();
        CATransaction.setAnimationDuration(1);
        
        let red = arc4random() / UInt32(Int32.max);
        let green = arc4random() / UInt32(Int32.max);
        let blue = arc4random() / UInt32(Int32.max);
        self.colorLayer.backgroundColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1.0).CGColor;
        CATransaction.commit();
    }
    //MARK: - 其他私有方法
    
    //MARK: - 内存管理相关
    func coreAnimationViewController4DataInit(){
    }
    
}
