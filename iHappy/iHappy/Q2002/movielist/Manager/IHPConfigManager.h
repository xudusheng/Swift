
//
//  IHPConfigManager.h
//  iHappy
//
//  Created by dusheng.xu on 2017/4/23.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IHPMenuModel.h"
@protocol IHPMenuModel;

@interface IHPConfigManager : JSONModel

@property (copy, nonatomic) NSString *rooturl;
@property (strong, nonatomic) NSArray<IHPMenuModel> *menus;

@end
