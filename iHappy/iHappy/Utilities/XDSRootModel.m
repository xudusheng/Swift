//
//  XDSRootModel.m
//  iHappy
//
//  Created by xudosom on 2016/11/19.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import "XDSRootModel.h"

@implementation XDSRootModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"用户信息  %@ = %@", key, value);
}
- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues{
    [XDSUtilities setPropertyWithClass:[self class] object:self keyedValues:keyedValues];
}
@end
