//
//  OCRootRequestViewController.m
//  Laomoney
//
//  Created by zhengda on 9/14/15.
//  Copyright (c) 2015 zhengda. All rights reserved.
//

#import "XDSRootRequestViewController.h"
#import "XDSHttpRequest.h"

@interface XDSRootRequestViewController ()

@end

@implementation XDSRootRequestViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _requestArray = [[NSMutableArray alloc]initWithCapacity:0];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    for (XDSHttpRequest * request in _requestArray) {
        [request cancelRequest];
    }
    [_requestArray removeAllObjects];
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
