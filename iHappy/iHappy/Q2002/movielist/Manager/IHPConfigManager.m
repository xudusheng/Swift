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
    
//    if (nil == manager.configModel) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"json"];
//        NSData *data = [NSData dataWithContentsOfFile:path];
//        NSError* err = nil;
//        IHPConfigModel *configModel = [[IHPConfigModel alloc] initWithData:data error:&err];
//        if (!err) {
//            [manager setConfigModel:configModel];
//        }else{
//            NSLog(@"error = %@", err);
//        }
//    }
    return manager;
}

- (void)configManagerWithJsondData:(NSData *)configData{
    NSError* err = nil;
    IHPConfigModel *configModel = [[IHPConfigModel alloc] initWithData:configData error:&err];
    if (!err) {
        [self setConfigModel:configModel];
    }else{
        NSLog(@"error = %@", err);
    }

}

- (IHPForceUpdateModel *)forceUpdate{
    return _configModel.forceUpdate;
}
- (NSArray<IHPMenuModel *> *)menus{
    NSMutableArray *availibleMenus = [NSMutableArray arrayWithCapacity:0];
    for (IHPMenuModel *aMenuModel in _configModel.menus) {
        if (aMenuModel.enable) {
            [availibleMenus addObject:aMenuModel];
        }
    }
    return availibleMenus;
}

- (void)setConfigModel:(IHPConfigModel *)configModel{
    _configModel = configModel;
}


@end
