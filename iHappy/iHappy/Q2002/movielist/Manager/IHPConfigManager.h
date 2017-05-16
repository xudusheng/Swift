
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

@property (nonatomic, readonly) IHPForceUpdateModel *forceUpdate;
@property (nonatomic, readonly) NSArray<IHPMenuModel *> *menus;
- (void)configManagerWithJsondData:(NSData *)configData;
@end
