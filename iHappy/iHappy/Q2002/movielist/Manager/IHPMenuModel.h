//
//  IHPMenuModel.h
//  iHappy
//
//  Created by dusheng.xu on 2017/4/23.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IHPSubMenuModel.h"

typedef NS_ENUM(NSInteger, IHPMenuType) {
    IHPMenuTypeQ2002 = 0,
    IHPMenuTypeQ2002Hot = 1,
    IHPMenuTypeQ2002New = 2,
    IHPMenuTypeJuheNews = 3,
    IHPMenuTypeBizhi    = 4,
};

@protocol IHPSubMenuModel;
@interface IHPMenuModel : JSONModel
@property (copy, nonatomic) NSString *title;//模块标题
@property (copy, nonatomic) NSString *menuId;//模块ID
@property (assign, nonatomic) IHPMenuType type;//模块类型
@property (copy, nonatomic) NSString *rooturl;//基础URL
@property (assign, nonatomic) BOOL enable;//模块是否可用，可用则显示，不可以则不显示，苹果审核期间《关闭》需要提交授权文件的模块。
@property (copy, nonatomic) NSArray<IHPSubMenuModel> * subMenus;

@end
