//
//  RedViewController.m
//  iHappy
//
//  Created by xudosom on 2016/11/19.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import "RedViewController.h"

@interface RedViewController ()
    
    @end

@implementation RedViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    // Do any additional setup after loading the view.
}
    
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[[XDSHttpRequest alloc] init] htmlRequestWithHref:@"http://www.q2002.com/type/2.html"
                                      hudController:self
                                            showHUD:YES
                                            HUDText:nil
                                      showFailedHUD:YES success:^(BOOL success, NSData *htmlData) {
                                          
                                      } failed:^(NSString *errorDescription) {
                                          
                                      }];
}
    
    @end
