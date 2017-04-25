//
//  IHPMenuModel.h
//  iHappy
//
//  Created by dusheng.xu on 2017/4/23.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IHPSubMenuModel.h"
@protocol IHPSubMenuModel;
@interface IHPMenuModel : JSONModel

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSArray<IHPSubMenuModel> * subMenus;

@end
