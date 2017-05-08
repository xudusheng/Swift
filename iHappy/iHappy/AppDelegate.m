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
#import "IHYInitialViewController.h"
#import "IHPConfigManager.h"
#import "IHPConfigModel.h"
#import "IHPMenuViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];

    [self showQ2002];
//    [self showNews];
    
//    IHYInitialViewController * initialVC = [[IHYInitialViewController alloc] init];
//    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:initialVC];
//    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    
    
    
//    NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"jquery" ofType:@"js"];
//    NSString *jsString = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];
//    NSLog(@"jsString = %@", jsString);
//    
//    
//    JSContext *context = [[JSContext alloc] init];
//    [context evaluateScript:jsString];
//    
//    JSValue *function = context[@"encodeURIComponent"];
//    JSValue *value = [function callWithArguments:@[@"bGllmXCflMaWlsljmmhunGlhZ2NnYcSf"]];
//    
//    NSLog(@"value = %@", value);

    
    
    return YES;
}


- (void)showQ2002{
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
    
    NSArray<IHPMenuModel*> *menus = [IHPConfigManager shareManager].menus;;
//    self.window.rootViewController = nav;
    
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

- (void)showNews{
//    类型,,top(头条，默认),shehui(社会),guonei(国内),guoji(国际),yule(娱乐),tiyu(体育)junshi(军事),keji(科技),caijing(财经),shishang(时尚)
//    http://v.juhe.cn/toutiao/index?type=top&key=APPKEY
//    http://v.juhe.cn/toutiao/index?type=top&key=f2b9c5a8243bc824253119ba09f7759a
    
    NSArray * arr = @[
                      @{@"title":@"头条", @"firstPageURL":@"http://v.juhe.cn/toutiao/index?type=top&key=f2b9c5a8243bc824253119ba09f7759a", @"type":@"0"},
                      @{@"title":@"社会", @"firstPageURL":@"http://v.juhe.cn/toutiao/index?type=shehui&key=f2b9c5a8243bc824253119ba09f7759a", @"type":@"0"},
                      @{@"title":@"国内", @"firstPageURL":@"http://v.juhe.cn/toutiao/index?type=guonei&key=f2b9c5a8243bc824253119ba09f7759a", @"type":@"0"},
                      @{@"title":@"国际", @"firstPageURL":@"http://v.juhe.cn/toutiao/index?type=guoji&key=f2b9c5a8243bc824253119ba09f7759a", @"type":@"0"},
                      @{@"title":@"娱乐", @"firstPageURL":@"http://v.juhe.cn/toutiao/index?type=yule&key=f2b9c5a8243bc824253119ba09f7759a", @"type":@"0"},
                      @{@"title":@"体育", @"firstPageURL":@"http://v.juhe.cn/toutiao/index?type=tiyu&key=f2b9c5a8243bc824253119ba09f7759a", @"type":@"0"},
                      @{@"title":@"军事", @"firstPageURL":@"http://v.juhe.cn/toutiao/index?type=junshi&key=f2b9c5a8243bc824253119ba09f7759a", @"type":@"0"},
                      @{@"title":@"财经", @"firstPageURL":@"http://v.juhe.cn/toutiao/index?type=caijing&key=f2b9c5a8243bc824253119ba09f7759a", @"type":@"0"},
                      @{@"title":@"时尚", @"firstPageURL":@"http://v.juhe.cn/toutiao/index?type=shishang&key=f2b9c5a8243bc824253119ba09f7759a", @"type":@"0"},
                      ];
    NSMutableArray * controllerModels = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * dic in arr) {
        IHYViewControllerModel * model = [[IHYViewControllerModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [controllerModels addObject:model];
    }
    
    IHYNewsMainViewController * newsMainVC = [[IHYNewsMainViewController alloc] init];
    newsMainVC.controllerModels = controllerModels;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:newsMainVC];
    self.window.rootViewController = nav;
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
