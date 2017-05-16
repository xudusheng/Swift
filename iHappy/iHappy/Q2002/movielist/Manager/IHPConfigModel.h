//
//  IHPConfigModel.h
//  iHappy
//
//  Created by dusheng.xu on 2017/4/25.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "IHPForceUpdateModel.h"
#import "IHPMenuModel.h"
@protocol IHPMenuModel;

@interface IHPConfigModel : JSONModel

@property (strong, nonatomic) IHPForceUpdateModel *forceUpdate;
@property (strong, nonatomic) NSArray<IHPMenuModel> *menus;
@end
