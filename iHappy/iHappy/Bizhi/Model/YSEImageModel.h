//
//  YSEImageModel.h
//  iHappy
//
//  Created by dusheng.xu on 2017/5/14.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSEImageModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *href;
@property (copy, nonatomic) NSString *width;
@property (copy, nonatomic) NSString *height;

- (void)p_setTitle:(NSString *)title
              href:(NSString *)href
             width:(NSString *)width
            height:(NSString *)height;

@end
