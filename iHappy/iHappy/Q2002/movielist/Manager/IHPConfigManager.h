
//
//  IHPConfigManager.h
//  iHappy
//
//  Created by dusheng.xu on 2017/4/23.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IHPConfigModel.h"
@class IHPMenuModel;

@interface IHPConfigManager : JSONModel

+ (instancetype)shareManager;
- (void)setConfigModel:(IHPConfigModel *)configModel;

@property (copy, nonatomic, readonly) NSString *rooturl;
@property (strong, nonatomic, readonly) IHPForceUpdateModel *forceUpdate;
@property (strong, nonatomic, readonly) NSArray<IHPMenuModel *> *menus;

@end
