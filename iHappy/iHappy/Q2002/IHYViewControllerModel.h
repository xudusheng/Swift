//
//  IHYViewControllerModel.h
//  iHappy
//
//  Created by xudosom on 2016/11/19.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import "XDSRootModel.h"

@interface IHYViewControllerModel : XDSRootModel
    
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * firstPageURL;
@property (strong, nonatomic) NSString * type;//0视频，1图片

@end
