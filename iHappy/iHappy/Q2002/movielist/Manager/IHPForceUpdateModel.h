//
//  IHPForceUpdateModel.h
//  iHappy
//
//  Created by dusheng.xu on 2017/4/25.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface IHPForceUpdateModel : JSONModel

@property (assign, nonatomic) BOOL enable;//是否需要升级
@property (assign, nonatomic) BOOL isForce;//是否强制升级
@property (copy, nonatomic) NSString *updateMessage;//升级信息
@property (copy, nonatomic) NSString *url;//升级下载地址

@end
