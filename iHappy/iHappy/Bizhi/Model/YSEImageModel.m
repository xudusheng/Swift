//
//  YSEImageModel.m
//  iHappy
//
//  Created by dusheng.xu on 2017/5/14.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import "YSEImageModel.h"

@implementation YSEImageModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"";
        self.href = @"";
        self.width = @"";
        self.height = @"";
    }
    return self;
}

- (void)p_setTitle:(NSString *)title href:(NSString *)href width:(NSString *)width height:(NSString *)height{
    self.title = title;
    self.href = href;
    self.width = width;
    self.height = height;
}

@end
