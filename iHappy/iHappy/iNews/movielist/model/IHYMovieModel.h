//
//  IHYMovieModel.h
//  iHappy
//
//  Created by xudosom on 2016/11/19.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import "XDSRootModel.h"

@interface IHYMovieModel : XDSRootModel
    
    @property (copy, nonatomic) NSString * name;
    @property (copy, nonatomic) NSString * href;
    @property (copy, nonatomic) NSString * imageurl;
    @property (copy, nonatomic) NSString * update;
    @property (copy, nonatomic) NSString * other;
    
@end
