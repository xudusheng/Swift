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
#import "XDSMasterViewController.h"
#import "XDSPlaceholdSplashViewController.h"

@interface AppDelegate ()

@property (nonatomic, weak) XDSPlaceholdSplashViewController * placeholdSplashViewController;

@property (nonatomic, strong) NLETaskQueue *launchTaskQueue;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    XDSMasterViewController * rootViewController = [XDSMasterViewController sharedRootViewController];
    self.window.rootViewController = rootViewController;

    [self showPlaceholderSplashView];
    [self stareLaunchQueue];

    
    return YES;
}

#pragma mark - Placehold Splash View methods
//- (void)showPlaceholderSplashViewWithViewController:(XDSPlaceholdSplashViewController *)viewController{
//    viewController.isCustomView = YES;
//    [self displayPlaceholderSplashView:viewController];
//}

- (void)removePlaceholderSplashView{
    [self.placeholdSplashViewController removeFromParentViewController];
    if (self.placeholdSplashViewController.view.superview) {
        [self.placeholdSplashViewController.view removeFromSuperview];
    }
    self.placeholdSplashViewController = nil;
}

- (void)showPlaceholderSplashView{
    XDSPlaceholdSplashViewController * placeholdSplashViewController = [[XDSPlaceholdSplashViewController alloc] init];
    [self displayPlaceholderSplashView:placeholdSplashViewController];
}

- (void)displayPlaceholderSplashView:(XDSPlaceholdSplashViewController *)viewController{
    [[XDSMasterViewController sharedRootViewController] addChildViewController:viewController];
    [[XDSMasterViewController sharedRootViewController].view addSubview:viewController.view];
    self.placeholdSplashViewController = viewController;
    [self.window makeKeyAndVisible];
}


NSString *const kIHPFetchConfigTaskID = @"IHPFetchConfigTask";
- (void)stareLaunchQueue{
    __weak typeof(self)weakSelf = self;
    self.launchTaskQueue = [NLETaskQueue taskQueue];
    NLETask * fetchConfigTask = [NLETask task];
    fetchConfigTask.taskId = kIHPFetchConfigTaskID;
    fetchConfigTask.taskContentBlock = ^(NLETask * task) {
        [weakSelf fetchConfigData];
    };
    [self.launchTaskQueue addTask:fetchConfigTask];
    [self.launchTaskQueue goWithFinishedBlock:^(NLETaskQueue *taskQueue) {
        [weakSelf removePlaceholderSplashView];
        [weakSelf showAppView];
    }];
}

- (void)finishTaskWithTaksID:(NSString *)taskID{
    NLETask *task = [self.launchTaskQueue taskWithTaskId:taskID];
    [task taskHasFinished];
}

- (void)fetchConfigData{
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"json"];
//    NSData *menuData = [NSData dataWithContentsOfFile:path];
//    NSLog(@"%@", [[NSString alloc] initWithData:menuData encoding:NSUTF8StringEncoding]);
//
//    IHPConfigManager *manager = [IHPConfigManager shareManager];
//    [manager configManagerWithJsondData:menuData];
//    
//    [self removePlaceholderSplashView];
//    [self showAppView];
//    
//    return;
    
//    NSString *requesturl = @"http://opno6uar4.bkt.clouddn.com/iHappy/menu_v1.0.3.json";
    NSString *requesturl = @"http://opno6uar4.bkt.clouddn.com/menu_v1.0.4.json";
    __weak typeof(self)weakSelf = self;
    [[[XDSHttpRequest alloc] init] htmlRequestWithHref:requesturl
                                         hudController:nil
                                               showHUD:NO
                                               HUDText:nil
                                         showFailedHUD:YES
                                               success:^(BOOL success, NSData * htmlData) {
                                                   NSLog(@"%@", [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding]);

                                                   IHPConfigManager *manager = [IHPConfigManager shareManager];
                                                   [manager configManagerWithJsondData:htmlData];
                                                   if (manager.forceUpdate.enable) {
                                                       if (manager.forceUpdate.isForce) {
                                                           [XDSUtilities alertViewWithPresentingController:[XDSMasterViewController sharedRootViewController]
                                                                                                     title:nil
                                                                                                   message:manager.forceUpdate.updateMessage
                                                                                              buttonTitles:@[@"退出", @"立即更新"]
                                                                                                     block:^(NSInteger index) {
                                                                                                         if (index == 0) {
                                                                                                             exit(0);
                                                                                                         }else{
                                                                                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:manager.forceUpdate.url]];
                                                                                                         }
                                                                                                     }];
                                                       }else{
                                                           [XDSUtilities alertViewWithPresentingController:[XDSMasterViewController sharedRootViewController]
                                                                                                     title:nil
                                                                                                   message:manager.forceUpdate.updateMessage
                                                                                              buttonTitles:@[@"稍后再说", @"立即更新"]
                                                                                                     block:^(NSInteger index) {
                                                                                                         if (index == 0) {
                                                                                                         }else{
                                                                                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:manager.forceUpdate.url]];
                                                                                                         }
                                                                                                         [weakSelf finishTaskWithTaksID:kIHPFetchConfigTaskID];
                                                                                                     }];

                                                       }
                                                       
                                                   }else{
                                                       [weakSelf finishTaskWithTaksID:kIHPFetchConfigTaskID];
                                                   }
                                                
                                               } failed:^(NSString *errorDescription) {
                                                   errorDescription = errorDescription?errorDescription:kLoadFailed;
                                                   [XDSUtilities alertViewWithPresentingController:[XDSMasterViewController sharedRootViewController]
                                                                                             title:nil
                                                                                           message:errorDescription
                                                                                      buttonTitles:@[@"退出", @"重新连接"]
                                                                                             block:^(NSInteger index) {
                                                                                                 if (index == 0) {
                                                                                                     exit(0);
                                                                                                 }else{
                                                                                                     [weakSelf fetchConfigData];
                                                                                                 }
                                                                                             }];
                                                   
                                               }];
}

- (void)showAppView{
    
    NSArray<IHPMenuModel*> *menus = [IHPConfigManager shareManager].menus;;
    
    self.leftMenu = [[IHPMenuViewController alloc] init];
    _leftMenu.menus = menus;
    
    self.contentController = [[IHYMainViewController alloc] init];
    _contentController.menuModel = menus.firstObject;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:_contentController];
//    self.window.rootViewController = nav;
//    return;
    
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





- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowRotation) {
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
//    return UIInterfaceOrientationMaskAll;

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
