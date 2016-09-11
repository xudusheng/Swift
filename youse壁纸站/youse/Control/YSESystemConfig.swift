//
//  YSESystemConfig.swift
//  youse
//
//  Created by xudosom on 16/8/29.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

import UIKit

class YSESystemConfig: NSObject {

    static internal func config(){
        
        let attributes = [NSForegroundColorAttributeName:UIColor.whiteColor()];
        UINavigationBar.appearance().titleTextAttributes = attributes;
        UINavigationBar.appearance().barTintColor = UIColor(red: 221/255.0, green: 133/255.0, blue: 184/255.0, alpha: 1);
        UIApplication.sharedApplication().statusBarStyle = .LightContent;
        
    }
}
