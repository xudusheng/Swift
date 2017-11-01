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

#import "PYSearch.h"

@interface IHYMainViewController ()<PYSearchViewControllerDelegate>

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

#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText {
    if (searchText.length) {
        // Simulate a send request to get a search suggestions
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
            for (int i = 0; i < searchViewController.searchHistories.count; i++) {
                NSString *historySearch = searchViewController.searchHistories[i];
                if ([historySearch.lowercaseString containsString:searchText.lowercaseString]) {
                    [searchSuggestionsM addObject:historySearch];
                }
            }
            // Refresh and display the search suggustions
            searchViewController.searchSuggestions = searchSuggestionsM;
        });
    }else {
        searchViewController.searchSuggestions = @[];
    }
}
#pragma mark - 点击事件处理
//TODO:菜单
- (void)showMenu{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.mainmeunVC presentLeftMenuViewController];
}

//TODO:搜索
- (void)showSearchVC{
//    IHPSearchViewController *searchVC = [[IHPSearchViewController alloc] init];
//    [self.navigationController pushViewController:searchVC animated:YES];
    // 1. Create an Array of popular search
    NSArray *hotSeaches = @[];
    // 2. Create a search view controller
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"输入视频关键词" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Called when search begain.
        // eg：Push to a temp view controller
        
        UIViewController *targetVC;
        IHPSubMenuModel * model = _menuModel.subMenus.firstObject;
        if (_menuModel.type == IHPMenuTypeJuheNews) {
            IHYNewsListViewController * newsVC = [[IHYNewsListViewController alloc]init];
            newsVC.rootUrl = _menuModel.rooturl;
            newsVC.firstPageUrl = model.url;
            targetVC = newsVC;
        }else if(_menuModel.type == IHPMenuTypeBizhi){
            IHPBiZhiListViewController * bizhiVC = [[IHPBiZhiListViewController alloc]init];
            bizhiVC.rootUrl = _menuModel.rooturl;
            bizhiVC.firstPageUrl = model.url;
            targetVC = bizhiVC;
        }else{
            NSString *url = @"http://www.q2002.com/search?wd=";
            url = [url stringByAppendingString:searchText];
            
            IHYMovieListViewController * movieVC = [[IHYMovieListViewController alloc]init];
            movieVC.firstPageUrl = url;
            movieVC.title = searchText;
            targetVC = movieVC;
        }
        [searchViewController.navigationController pushViewController:targetVC animated:YES];
    }];
    // 3. Set style for popular search and search history
    searchViewController.hotSearchStyle = PYHotSearchStyleDefault;
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
    // 4. Set delegate
    searchViewController.delegate = self;
    // 5. Present a navigation controller
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:YES completion:nil];
    
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


//// New Autorotation support.
////是否自动旋转,返回YES可以自动旋转
//- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0) __TVOS_PROHIBITED {
//    return YES;
//}
////返回支持的方向
//#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
//- (NSUInteger)supportedInterfaceOrientations
//#else
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//#endif
//{
//    return UIInterfaceOrientationMaskAll;
//}


@end
