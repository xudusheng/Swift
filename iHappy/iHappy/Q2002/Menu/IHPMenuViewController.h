//
//  IHPMenuViewController.h
//  iHappy
//
//  Created by dusheng.xu on 2017/4/25.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDSSideMenu.h"
@interface IHPMenuViewController : UIViewController <XDSSideMenuDelegate>

@property (copy, nonatomic) NSArray<IHPMenuModel *> *menus;

@end
