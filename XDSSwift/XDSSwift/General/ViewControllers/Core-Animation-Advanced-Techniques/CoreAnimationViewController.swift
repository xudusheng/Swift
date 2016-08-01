//
//  CoreAnimationViewController.swift
//  XDSSwift
//
//  Created by zhengda on 16/7/26.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class CoreAnimationViewController: XDSRootViewController {
    var secondPointer:UIView?;
    var minutePointer:UIView?;
    var hourPointer:UIView?;
    var timer:NSTimer?;
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        self.timer?.invalidate();
        self.timer = nil;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.swiftRootTableViewControllerDataInit();
        self.createSwiftRootTableViewControllerUI();
    }

    //MARK: - UI相关
    func createSwiftRootTableViewControllerUI(){
        self.mapImage();
//        self.createClock();
    }
    
    //TODO:时钟
    func createClock() -> Void {
        let clock = UIView(frame: CGRectMake(0, 0, 300, 300));
        clock.center = self.view.center;
        clock.backgroundColor = UIColor.redColor();
        self.view.addSubview(clock);
        let clockCenter = CGPointMake(CGRectGetWidth(clock.frame)/2, CGRectGetHeight(clock.frame)/2);
        var center = clockCenter;
        self.hourPointer = UIView(frame: CGRectMake(0, 0, 20, 80));
        self.hourPointer?.backgroundColor = UIColor.blueColor();
        self.hourPointer?.center = center;
        self.hourPointer?.layer.anchorPoint = CGPointMake(0.5, 1);
        clock.addSubview(self.hourPointer!);
        
        center = clockCenter;
        self.minutePointer = UIView(frame: CGRectMake(0, 0, 16, 100));
        self.minutePointer?.backgroundColor = UIColor.brownColor();
        self.minutePointer?.center = center;
        self.minutePointer?.layer.anchorPoint = CGPointMake(0.5, 1);
        clock.addSubview(self.minutePointer!);
        
        center = clockCenter;
        self.secondPointer = UIView(frame: CGRectMake(0, 0, 12, 120));
        self.secondPointer?.backgroundColor = UIColor.greenColor();
        self.secondPointer?.center = center;
        self.secondPointer?.layer.anchorPoint = CGPointMake(0.5, 1);
        clock.addSubview(self.secondPointer!);
        self.hourPointer?.layer.zPosition = 1.0;
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(CoreAnimationViewController.clockCountDown), userInfo: nil, repeats: true);
        self.clockCountDown();
    }
    //TODO:为layer写图片
    func mapImage() -> Void {
        let layerView = UIView(frame: CGRectMake(0, 0, 200, 200));
        layerView.backgroundColor = UIColor.brownColor();
        layerView.center = self.view.center;
        self.view.addSubview(layerView);
        
        let snowmanImage:UIImage! = UIImage(named: "snowman");
        layerView.layer.contents = snowmanImage.CGImage;
        layerView.layer.contentsGravity = kCAGravityCenter;
        layerView.layer.contentsScale = snowmanImage.scale;
        
        var transforms = CGAffineTransformIdentity;
//        transforms = CGAffineTransformScale(transforms, 0.5, 0.5);//缩放
//        transforms = CGAffineTransformTranslate(transforms, 200, 0);//平移
//        transforms = CGAffineTransformRotate(transforms, CGFloat(M_PI_4));//旋转
        
        //斜切
        transforms.c = -1;
        transforms.b = 0;
        
        layerView.layer.setAffineTransform(transforms);

        
//        let mapImage = UIImage(named: "map.bmp");
//        layerView.layer.contents = mapImage?.CGImage;
//        layerView.layer.contentsGravity = kCAGravityResizeAspect;
//        layerView.layer.contentsRect = CGRectMake(0.5, 0.5, 0.5, 0.5);
    }
    
    
    //MARK: - 代理方法

    //MARK: - 网络请求
    
    //MARK: - 事件响应处理
    func clockCountDown() -> Void {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian);
        let units:NSCalendarUnit = [.Hour, .Minute, .Second]
        let components = calendar?.components(units, fromDate: NSDate());
        let secAngle = Double(components!.second) / 60.0 * M_PI * 2.0;
        let minsAngle = (Double(components!.minute) + Double(components!.second) / 60.0) / 60.0 * M_PI * 2.0;
        let hoursAngle = (Double(components!.hour) + Double(components!.minute) / 60.0) / 12.0 * M_PI * 2.0;

        print("\(hoursAngle)===\(minsAngle)===\(secAngle)")
        self.hourPointer!.transform = CGAffineTransformMakeRotation(CGFloat(hoursAngle));
        self.minutePointer!.transform = CGAffineTransformMakeRotation(CGFloat(minsAngle));
        self.secondPointer!.transform = CGAffineTransformMakeRotation(CGFloat(secAngle));
    }
    //MARK: - 其他私有方法
    
    //MARK: - 内存管理相关
    func swiftRootTableViewControllerDataInit(){
        
    }

    
}
