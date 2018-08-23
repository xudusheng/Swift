//
//  InMobViewController.m
//  q2002_react_native
//
//  Created by zhengda on 16/11/9.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "InMobViewController.h"
#import "XDSInMobiAdView.h"
@interface InMobViewController ()

@end

@implementation InMobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  CGFloat width = [UIScreen mainScreen].bounds.size.width;
  XDSInMobiAdView * adView =[[XDSInMobiAdView alloc]initWithFrame:CGRectMake(0, 0, width, 50)];
  adView.backgroundColor = [UIColor yellowColor];
  [self.view addSubview:adView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
