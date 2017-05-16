//
//  YSEClassifyModel.h
//  iHappy
//
//  Created by dusheng.xu on 2017/5/13.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSEClassifyModel : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *href;

- (void)p_setName:(NSString *)name href:(NSString *)href;

@end
