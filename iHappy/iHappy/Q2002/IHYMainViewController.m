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
#import "AppDelegate.h"
#import "IHPSearchViewController.h"
#import "IHYNewsListViewController.h"
#import "IHPBiZhiListViewController.h"
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
    [self setBarItems];
    
}
- (void)setBarItems{
    if ([IHPConfigManager shareManager].menus.count > 1) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_menu_icon"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(showMenu)];
        self.navigationItem.leftBarButtonItem = leftItem;
    }else{
        self.navigationItem.leftBarButtonItem = nil;
    }
    
    if (_menuModel.type < IHPMenuTypeJuheNews) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索"
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(showSearchVC)];
        self.navigationItem.rightBarButtonItem = rightItem;
        
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark - 网络请求

#pragma mark - 代理方法
#pragma mark - WMPageControllerDataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return _menuModel.subMenus.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    IHPSubMenuModel * model = _menuModel.subMenus[index];
    if (_menuModel.type == IHPMenuTypeJuheNews) {
        IHYNewsListViewController * newsVC = [[IHYNewsListViewController alloc]init];
        newsVC.rootUrl = _menuModel.rooturl;
        newsVC.firstPageUrl = model.url;
        return newsVC;
    }else if(_menuModel.type == IHPMenuTypeBizhi){
        IHPBiZhiListViewController * bizhiVC = [[IHPBiZhiListViewController alloc]init];
        bizhiVC.rootUrl = _menuModel.rooturl;
        bizhiVC.firstPageUrl = model.url;
        return bizhiVC;
        
    }else{
        IHYMovieListViewController * movieVC = [[IHYMovieListViewController alloc]init];
        movieVC.rootUrl = _menuModel.rooturl;
        movieVC.firstPageUrl = model.url;
        return movieVC;
    }
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    IHPSubMenuModel * model = _menuModel.subMenus[index];
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
//TODO:菜单
- (void)showMenu{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.mainmeunVC presentLeftMenuViewController];
}

//TODO:搜索
- (void)showSearchVC{
    IHPSearchViewController *searchVC = [[IHPSearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
#pragma mark - 其他私有方法
- (void)setMenuModel:(IHPMenuModel *)menuModel{
    _menuModel = menuModel;
    self.title = _menuModel.title;
    [self reloadData];
    
    
    [self setBarItems];

}

#pragma mark - 内存管理相关
- (void)mainViewControllerDataInit{
    
}




@end
