//
//  IHYMainViewController.m
//  iHappy
//
//  Created by xudosom on 2016/11/19.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import "IHYMainViewController.h"
#import "IHYMovieListViewController.h"
#import "IHPMenuViewController.h"

@interface IHYMainViewController ()

@end

@implementation IHYMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self mainViewControllerDataInit];
    [self createMainViewControllerUI];
    [self reloadData];
}



#pragma mark - UI相关
- (void)createMainViewControllerUI{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"菜单"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(showMenu)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark - 网络请求

#pragma mark - 代理方法
#pragma mark - WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.controllerModels.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    IHYViewControllerModel * model = _controllerModels[index];
    IHYMovieListViewController * movieVC = [[IHYMovieListViewController alloc]init];
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
#pragma mark - 点击事件处理

- (void)showMenu{
    IHPMenuViewController *menu = [[IHPMenuViewController alloc] init];
    [self.navigationController pushViewController:menu animated:YES];
}

#pragma mark - 其他私有方法

#pragma mark - 内存管理相关
- (void)mainViewControllerDataInit{
    
}




@end
