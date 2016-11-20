//
//  XDSRootViewController.m
//  Jurongbao
//
//  Created by wangrongchao on 15/10/17.
//  Copyright © 2015年 truly. All rights reserved.
//

#import "XDSRootViewController.h"

@interface XDSRootViewController ()

@end

@implementation XDSRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_back"] style:UIBarButtonItemStyleDone target:self action:@selector(popBack:)];
    barButtonItem.tintColor = [UIColor whiteColor];
    barButtonItem.tintColor = [UIColor brownColor];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}


- (void)popBack:(UIBarButtonItem *)barButtonItem{
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(self.navigationController.presentingViewController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
