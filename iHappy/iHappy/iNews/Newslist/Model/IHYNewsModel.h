//
//  IHYNewsModel.h
//  iHappy
//
//  Created by zhengda on 16/11/21.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import "XDSRootModel.h"

@interface IHYNewsModel : XDSRootModel

@property (nonatomic, copy)NSString * author_name;
@property (nonatomic, copy)NSString * date;
@property (nonatomic, copy)NSString * realtype;
@property (nonatomic, copy)NSString * thumbnail_pic_s;
@property (nonatomic, copy)NSString * thumbnail_pic_s02;
@property (nonatomic, copy)NSString * thumbnail_pic_s03;
@property (nonatomic, copy)NSString * title;
@property (nonatomic, copy)NSString * type;
@property (nonatomic, copy)NSString * uniquekey;
@property (nonatomic, copy)NSString * url;

- (BOOL)isMultableImageNews;

@end

