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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];

    [self showQ2002];
//    [self showNews];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)showQ2002{
    NSArray * arr = @[
                      @{@"title":@"电影", @"firstPageURL":@"http://www.q2002.com/type/1.html", @"type":@"0"},
                      @{@"title":@"电视剧", @"firstPageURL":@"http://www.q2002.com/type/2.html", @"type":@"0"},
                      @{@"title":@"动漫", @"firstPageURL":@"http://www.q2002.com/type/7.html", @"type":@"0"},
                      @{@"title":@"音乐", @"firstPageURL":@"http://www.q2002.com/type/6.html", @"type":@"0"},
                      @{@"title":@"综艺", @"firstPageURL":@"http://www.q2002.com/type/4.html", @"type":@"0"},
                      @{@"title":@"福利", @"firstPageURL":@"http://www.q2002.com/type/3.html", @"type":@"0"},
                      @{@"title":@"美图", @"firstPageURL":@"http://www.q2002.com/type/20.html", @"type":@"1"},
                      ];
    NSMutableArray * controllerModels = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * dic in arr) {
        IHYViewControllerModel * model = [[IHYViewControllerModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [controllerModels addObject:model];
    }
    
    IHYMainViewController * mainController = [[IHYMainViewController alloc] init];
    mainController.controllerModels = controllerModels;
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:mainController];
    self.window.rootViewController = nav;
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
