//
//  IHPSubMenuModel.h
//  iHappy
//
//  Created by dusheng.xu on 2017/4/23.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IHPSubMenuType) {
    IHPSubMenuTypeVideo = 0,
    IHPSubMenuTypePicture,
};
@interface IHPSubMenuModel : JSONModel

@property (copy, nonatomic) NSString *title;

@property (copy, nonatomic) NSString *url;

@property (assign, nonatomic) IHPSubMenuType type;

@end
