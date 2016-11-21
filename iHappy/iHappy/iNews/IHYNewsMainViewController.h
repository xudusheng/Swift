//
//  IHYNewsMainViewController
//  iHappy
//
//  Created by xudosom on 2016/11/19.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import <WMPageController/WMPageController.h>
#import "IHYViewControllerModel.h"
@interface IHYNewsMainViewController : WMPageController
    
@property (copy, nonatomic) NSArray<IHYViewControllerModel *> * controllerModels;
    
@end
