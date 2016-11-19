//
//  XDSRootRequestTableViewController.m
//  Laomoney
//
//  Created by zhengda on 9/14/15.
//  Copyright (c) 2015 zhengda. All rights reserved.
//

#import "XDSRootRequestTableViewController.h"
#import "XDSHttpRequest.h"

@interface XDSRootRequestTableViewController ()

@end

@implementation XDSRootRequestTableViewController

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
@end
