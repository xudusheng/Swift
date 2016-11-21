//
//  IHYInitialViewController.m
//  iHappy
//
//  Created by zhengda on 16/11/21.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import "IHYInitialViewController.h"
#import "AppDelegate.h"
@interface IHYInitialViewController ()
@property (strong, nonatomic) UITextField * textField;
@end

@implementation IHYInitialViewController
- (void)dealloc{
    NSLog(@"%@ ==> dealloc", [self class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialViewControllerDataInit];
    [self createInitialViewControllerUI];
}

#pragma mark - UI相关
- (void)createInitialViewControllerUI{
    self.view.backgroundColor = [UIColor whiteColor];

    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    textField.placeholder = @"输入版本号";
    textField.textAlignment = NSTextAlignmentCenter;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.center = self.view.center;
    [self.view addSubview:textField];
    self.textField = textField;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect buttonFrame = textField.frame;
    buttonFrame.origin.y = CGRectGetMaxY(buttonFrame) + 20;
    button.frame =buttonFrame;
    [button setTitle:@"进入版本" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor brownColor]];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

#pragma mark - 网络请求
- (void)check:(NSString *)version{
    NSString * objectId = [version compare:@"1.0.1"] == NSOrderedSame ? @"p3GRIIIM" : @"OEQv7779";
    
//    NSString * url = [NSString stringWithFormat:@"https://api.bmob.cn/1/classes/Config?where={\"version\":\"%@\"}", version];

    NSString * url = @"https://api.bmob.cn/1/classes/Config/";
    url = [url stringByAppendingString:objectId];
    [[[XDSHttpRequest alloc] init] queryInitialInfoWithUrlString:url
                                           reqParam:nil
                                      hudController:self
                                            showHUD:NO
                                            HUDText:nil
                                      showFailedHUD:YES
                                            success:^(BOOL success, NSDictionary *successResult) {
                                                NSLog(@"successResult = %@", successResult);
                                                if (success) {
                                                    NSString * isAppStoreOnChecking = [XDSUtilities stringFromidString:successResult[@"isAppStoreOnChecking"]];
                                                    if (isAppStoreOnChecking.boolValue) {//正在审核
                                                        [(AppDelegate *)[UIApplication sharedApplication].delegate showNews];
                                                    }else{//已通过审核
                                                        [(AppDelegate *)[UIApplication sharedApplication].delegate showQ2002];
                                                    }
                                                }
                                                
                                            } failed:^(NSString *errorDescription) {
                                                
                                            }];
}
#pragma mark - 代理方法

#pragma mark - 点击事件处理
- (void)buttonClick:(UIButton *)button{
    if (_textField.text.trimString.length < 1) {
        [XDSUtilities showHud:@"请输入版本号" rootView:self.navigationController.view hideAfter:1.2];
        return;
    }
    
    [self check:_textField.text.trimString];
}
#pragma mark - 其他私有方法

#pragma mark - 内存管理相关
- (void)initialViewControllerDataInit{
    
}


@end
