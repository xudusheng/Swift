//
//  INSImageItemCollectionViewCell.h
//  iHappy
//
//  Created by dusheng.xu on 2017/5/14.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSEImageModel.h"

UIKIT_EXTERN NSString *const kImageItemCollectionViewCellIdentifier;

@interface INSImageItemCollectionViewCell : IHPRootCollectionCell

@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) YSEImageModel *imageModel;

@end
