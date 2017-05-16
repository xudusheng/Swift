//
//  IHPBiZhiListViewController.h
//  iHappy
//
//  Created by dusheng.xu on 2017/5/13.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import "XDSRootRequestViewController.h"
#import "YSEClassifyModel.h"
@interface IHPBiZhiListViewController : XDSRootRequestViewController

@property (strong, nonatomic) YSEClassifyModel *classifyModel;//第一页、当前被选中的分类model
@property (copy, nonatomic) NSString * rootUrl;
@property (copy, nonatomic) NSString * firstPageUrl;

@end
