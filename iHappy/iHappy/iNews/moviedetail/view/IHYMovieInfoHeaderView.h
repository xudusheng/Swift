//
//  IHYMovieInfoHeaderView.h
//  iHappy
//
//  Created by xudosom on 2016/11/20.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IHYMovieDetailInfoView.h"

@interface IHYMovieInfoHeaderView : UIView

- (void)movieInfoHeaderWithMovieImage:(NSString *)href
                               sumary:(NSString *)sumary
                titlaAndContentModels:(NSArray<IHYMovieDetailInfoTitleAndContentModel *> *)titlaAndContentModels;

@end
