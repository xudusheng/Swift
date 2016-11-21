//
//  IHYNewsModel.m
//  iHappy
//
//  Created by zhengda on 16/11/21.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import "IHYNewsModel.h"

@implementation IHYNewsModel

- (BOOL)isMultableImageNews{
    
    return NO;
    BOOL notNull = (_thumbnail_pic_s.length && _thumbnail_pic_s02.length) ||
    (_thumbnail_pic_s02.length && _thumbnail_pic_s03.length) ||
    (_thumbnail_pic_s03.length && _thumbnail_pic_s.length);
    BOOL isEquel = NO;
    
    if (_thumbnail_pic_s.length < 1) {
        isEquel = [_thumbnail_pic_s02 isEqualToString:_thumbnail_pic_s03];
    }else if (_thumbnail_pic_s02.length < 1){
        isEquel = [_thumbnail_pic_s03 isEqualToString:_thumbnail_pic_s];
    }else if (_thumbnail_pic_s03.length < 1){
        isEquel =     [_thumbnail_pic_s isEqualToString:_thumbnail_pic_s02];
    }else{
        isEquel = [_thumbnail_pic_s isEqualToString:_thumbnail_pic_s02] &&
        [_thumbnail_pic_s02 isEqualToString:_thumbnail_pic_s03] &&
        [_thumbnail_pic_s03 isEqualToString:_thumbnail_pic_s];
    }
    
    return (notNull && !isEquel);
}

@end
