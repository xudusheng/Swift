//
//  IHPMenuViewController.m
//  iHappy
//
//  Created by dusheng.xu on 2017/4/25.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import "IHPMenuViewController.h"
#import "AppDelegate.h"
@interface IHPMenuViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *menuTable;
@property (copy, nonatomic) NSArray *menuList;
@end

@implementation IHPMenuViewController
static NSString *kMenuTableViewCellIdentifier = @"MenuTableViewCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self menuViewControllerDataInit];
    [self createMenuViewControllerUI];
}


#pragma mark - UI相关
- (void)createMenuViewControllerUI{
    self.menuTable = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kMenuTableViewCellIdentifier];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView;
    });
}

#pragma mark - 网络请求

#pragma mark - 代理方法
#pragma mark UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _menuList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMenuTableViewCellIdentifier forIndexPath:indexPath];
    
    IHPMenuModel *theMenu = _menuList[indexPath.row];
    cell.textLabel.text = theMenu.title;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.mainmeunVC hideMenuViewController];
    
    IHPMenuModel *theMenu = _menuList[indexPath.row];
    delegate.contentController.menuModel = theMenu;
}


#pragma mark - XDSSideMenuDelegate


#pragma mark - 点击事件处理

#pragma mark - 其他私有方法

#pragma mark - 内存管理相关
- (void)menuViewControllerDataInit{
    self.menuList = [IHPConfigManager shareManager].menus;
}



@end
