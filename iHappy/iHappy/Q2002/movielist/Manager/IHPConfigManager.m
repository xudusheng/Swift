//
//  IHPConfigManager.m
//  iHappy
//
//  Created by dusheng.xu on 2017/4/23.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import "IHPConfigManager.h"
@interface IHPConfigManager()
@property (strong, nonatomic) IHPConfigModel *configModel;
@end
@implementation IHPConfigManager

+ (instancetype)shareManager{
    static IHPConfigManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[IHPConfigManager alloc] init];
    });
    return manager;
}


- (NSString *)rooturl{
    return _configModel.rooturl;
}

- (IHPForceUpdateModel *)forceUpdate{
    return _configModel.forceUpdate;
}
- (NSArray<IHPMenuModel *> *)menus{
    return _configModel.menus;
}

- (void)setConfigModel:(IHPConfigModel *)configModel{
    _configModel = configModel;
}


@end
