//
//  IHYMovieDetailInfoView.h
//  iHappy
//
//  Created by xudosom on 2016/11/20.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IHYMovieDetailInfoViewInitialHeight 220
@interface IHYMovieDetailInfoTitleAndContentModel : XDSRootModel
@property (copy, nonatomic) NSString * title;
@property (copy, nonatomic) NSString * content;
@end

@interface IHYMovieDetailInfoView : UIView

- (void)movieDetailInfoWithMovieImage:(NSString *)href
                               sumary:(NSString *)sumary
                titlaAndContentModels:(NSArray<IHYMovieDetailInfoTitleAndContentModel *> *)titlaAndContentModels;

@end
