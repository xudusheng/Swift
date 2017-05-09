//
//  AppDelegate.m
//  iHappy
//
//  Created by xudosom on 2016/11/19.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "IHYMainViewController.h"
#import "IHYNewsMainViewController.h"
#import "IHPConfigManager.h"
#import "IHPConfigModel.h"
#import "IHPMenuViewController.h"

#import "NLETaskQueue.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];

    [self stareLaunchQueue];

    [self.window makeKeyAndVisible];
    
    return YES;
}

NSString *const kIHPFetchConfigTaskID = @"IHPFetchConfigTask";

- (void)stareLaunchQueue{
    
    __weak typeof(self)weakSelf = self;
    NLETaskQueue *launchTaskQueue = [NLETaskQueue taskQueue];
    NLETask * fetchConfigTask = [NLETask task];
    fetchConfigTask.taskId = kIHPFetchConfigTaskID;
    fetchConfigTask.taskContentBlock = ^(NLETask * task) {
        [weakSelf fetchConfigData];
    };
    [launchTaskQueue addTask:fetchConfigTask];
    [launchTaskQueue goWithFinishedBlock:^(NLETaskQueue *taskQueue) {
        [weakSelf showAppView];
    }];
    
}

- (void)fetchConfigData{
    NSString *requesturl = @"http://opno6uar4.bkt.clouddn.com/iHappy/menu.json";
    __weak typeof(self)weakSelf = self;
    [[[XDSHttpRequest alloc] init] htmlRequestWithHref:requesturl
                                         hudController:nil
                                               showHUD:NO
                                               HUDText:nil
                                         showFailedHUD:YES
                                               success:^(BOOL success, NSData * htmlData) {
                                                   if (success) {
                                                       NSLog(@"%@", [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding]);
                                                   }else{
                                                       //                                                       [XDSUtilities showHud:@"数据请求失败，请稍后重试" rootView:self.window hideAfter:1.2];
                                                   }
                                               } failed:^(NSString *errorDescription) {
                                                   
                                                   
                                               }];
}

- (void)showAppView{
    
    NSArray<IHPMenuModel*> *menus = [IHPConfigManager shareManager].menus;;
    
    self.leftMenu = [[IHPMenuViewController alloc] init];
    _leftMenu.menus = menus;
    
    self.contentController = [[IHYMainViewController alloc] init];
    _contentController.menuModel = menus.firstObject;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:_contentController];
    self.mainmeunVC = [[XDSSideMenu alloc] initWithContentViewController:nav
                                                  leftMenuViewController:_leftMenu
                                                 rightMenuViewController:nil];
    self.mainmeunVC.contentViewInLandscapeOffsetCenterX = -480;
    self.mainmeunVC.contentViewShadowColor = [UIColor lightGrayColor];
    self.mainmeunVC.contentViewShadowOffset = CGSizeMake(0, 0);
    self.mainmeunVC.contentViewShadowOpacity = 0.6;
    self.mainmeunVC.contentViewShadowRadius = 12;
    self.mainmeunVC.contentViewShadowEnabled = NO;
    self.mainmeunVC.scaleMenuView = NO;
    self.mainmeunVC.scaleContentView = NO;
    self.mainmeunVC.parallaxEnabled = NO;
    self.mainmeunVC.bouncesHorizontally = NO;
    
    
    self.mainmeunVC.panGestureEnabled = YES;
    self.mainmeunVC.panFromEdge = YES;
    self.mainmeunVC.panMinimumOpenThreshold = 60.0;
    self.mainmeunVC.bouncesHorizontally = NO;
    
    self.mainmeunVC.delegate = _leftMenu;
    
    self.window.rootViewController = self.mainmeunVC;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
