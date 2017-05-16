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

@property (strong, nonatomic) UISearchController *searchVC;
@property (strong, nonatomic) IHPSearchViewController *searchResultVC;

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
    
    self.searchResultVC = [[IHPSearchViewController alloc] init];
    self.searchVC = ({
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_searchResultVC];
        UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nav];
        //设置后可以看到实时输入内容,可以在结果页的代理里面设置输入长度
        [searchController setSearchResultsUpdater: _searchResultVC];
        [searchController.searchBar setPlaceholder:@"搜索"];
        [searchController.searchBar setBarTintColor:[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]];
        //设置搜索logo
        [searchController.searchBar setImage:[UIImage imageNamed:@"last.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        [searchController.searchBar sizeToFit];
        [searchController.searchBar setDelegate:_searchResultVC];
        searchController.hidesNavigationBarDuringPresentation = NO;
        
//        [searchController.searchBar.layer setBorderWidth:0.5f];
//        [searchController.searchBar.layer setBorderColor:[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0].CGColor];
        
//        searchController.searchBar.frame = CGRectMake(0, 64, 300, 44);
//        [self.view addSubview:searchController.searchBar];
        self.navigationItem.titleView = searchController.searchBar;
        _searchResultVC.searchVC = searchController;
        searchController;
    });
    
    
    
    
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
