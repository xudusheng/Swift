//
//  XDSMainTabBarController.swift
//  XDSSwift
//
//  Created by xudosom on 16/8/7.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class XDSMainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let transition = CATransition();
        transition.type = kCATransitionFade;
        self.view.layer.add(transition, forKey: nil);
        
    }

}
