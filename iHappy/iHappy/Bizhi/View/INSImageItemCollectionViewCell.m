//
//  INSImageItemCollectionViewCell.m
//  iHappy
//
//  Created by dusheng.xu on 2017/5/14.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import "INSImageItemCollectionViewCell.h"

NSString *const kImageItemCollectionViewCellIdentifier = @"INSImageItemCollectionViewCell";

@implementation INSImageItemCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createImageItemCollectionViewCellUI];
    }
    return self;
}


//MARK:UI
- (void)createImageItemCollectionViewCellUI{
    self.bgImageView = ({
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.backgroundColor = [UIColor lightGrayColor];
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:imageView];
        imageView;
    });

    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [self.contentView addSubview:label];
        label;
        
    });

    
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_bgImageView, _titleLabel);
    
    NSArray *bgImageView_h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bgImageView]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:viewsDict];
    NSArray *bgImageView_v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_bgImageView]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:viewsDict];
    NSArray *titleLabel_h = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleLabel]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:viewsDict];
    NSArray *titleLabel_v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel(==25)]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:viewsDict];
    
    [self.contentView addConstraints:bgImageView_h];
    [self.contentView addConstraints:bgImageView_v];
    [self.contentView addConstraints:titleLabel_h];
    [self.contentView addConstraints:titleLabel_v];
    
}


- (void)p_loadCell{
    if (self.imageModel == nil) {
        return;
    }
    NSURL *url = [NSURL URLWithString:_imageModel.href];
    [_bgImageView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageTransformAnimatedImage];
    _titleLabel.text = _imageModel.title;
}

@end
