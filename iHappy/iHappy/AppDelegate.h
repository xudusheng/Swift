//
//  AppDelegate.h
//  iHappy
//
//  Created by xudosom on 2016/11/19.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDSSideMenu.h"
#import "IHPMenuViewController.h"
#import "IHYMainViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/***  是否允许横屏的标记 */
@property (nonatomic,assign)BOOL allowRotation;

@property (nonatomic, strong) XDSSideMenu* mainmeunVC;
@property (nonatomic, strong) IHPMenuViewController *leftMenu;
@property (nonatomic, strong) IHYMainViewController * contentController;



@end

