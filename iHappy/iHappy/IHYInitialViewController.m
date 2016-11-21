//
//  IHYInitialViewController.m
//  iHappy
//
//  Created by zhengda on 16/11/21.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import "IHYInitialViewController.h"

@interface IHYInitialViewController ()

@end

@implementation IHYInitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialViewControllerDataInit];
    [self createInitialViewControllerUI];
}

#pragma mark - UI相关
- (void)createInitialViewControllerUI{
    [[[XDSHttpRequest alloc] init] GETWithURLString:@""
                                           reqParam:nil
                                      hudController:self
                                            showHUD:NO
                                            HUDText:nil
                                      showFailedHUD:YES
                                            success:^(BOOL success, NSDictionary *successResult) {
                                                
                                            } failed:^(NSString *errorDescription) {
                                                
                                            }];
}

#pragma mark - 网络请求

#pragma mark - 代理方法

#pragma mark - 点击事件处理

#pragma mark - 其他私有方法

#pragma mark - 内存管理相关
- (void)initialViewControllerDataInit{
    
}


@end
