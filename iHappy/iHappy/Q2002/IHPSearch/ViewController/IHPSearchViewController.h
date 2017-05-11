//
//  IHPSearchViewController.h
//  iHappy
//
//  Created by dusheng.xu on 2017/5/5.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IHPSearchViewController : XDSRootViewController<UISearchResultsUpdating, UISearchBarDelegate>

@property (strong, nonatomic) UISearchController *searchVC;


@end
