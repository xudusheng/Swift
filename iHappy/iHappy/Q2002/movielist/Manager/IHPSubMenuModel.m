//
//  IHPSubMenuModel.m
//  iHappy
//
//  Created by dusheng.xu on 2017/4/23.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import "IHPSubMenuModel.h"
@interface IHPSubMenuModel ()

//@property (strong, nonatomic) NSString *firstPageURL;

@end
@implementation IHPSubMenuModel

- (NSString *)firstPageURL{
    if ([_url hasPrefix:@"http:"] || [_url hasPrefix:@"https:"]) {
        return _url;
    }
    return [[IHPConfigManager shareManager].rooturl stringByAppendingString:_url];
}

@end
