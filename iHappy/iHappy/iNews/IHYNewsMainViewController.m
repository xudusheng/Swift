//
//  IHYNewsMainViewController.m
//  iHappy
//
//  Created by xudosom on 2016/11/19.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import "IHYNewsMainViewController.h"
#import "IHYNewsListViewController.h"

@interface IHYNewsMainViewController ()
    
    @end

@implementation IHYNewsMainViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];    
    [self reloadData];
}
    
#pragma mark - WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.controllerModels.count;
}
    
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    IHYViewControllerModel * model = _controllerModels[index];
    IHYNewsListViewController * movieVC = [[IHYNewsListViewController alloc]init];
    movieVC.firstPageUrl = model.firstPageURL;
    return movieVC;
}
    
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    IHYViewControllerModel * model = _controllerModels[index];
    return model.title;
}
    
- (void)pageController:(WMPageController *)pageController lazyLoadViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    NSLog(@"%@", info);
}
    
- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    NSLog(@"%@", info);
}
    
    
- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    NSLog(@"%s", __FUNCTION__);
}
    
- (void)menuView:(WMMenuView *)menu didLayoutItemFrame:(WMMenuItem *)menuItem atIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromCGRect(menuItem.frame));
}
    
    
    @end
