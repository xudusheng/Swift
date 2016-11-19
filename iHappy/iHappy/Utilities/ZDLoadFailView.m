//
//  ZALoadFailView.m
//  Thumb
//
//  Created by zhengda on 15/4/17.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "ZDLoadFailView.h"

@interface ZDLoadFailView()

@property (nonatomic, copy)void(^clickBlock)(void);

@end

@implementation ZDLoadFailView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title topGap:(CGFloat)topGap{
    if (self = [super initWithFrame:frame]) {
        [self createZDLoadFailViewWithTitle:title topGap:topGap];
    }
    return self;
}


- (void)createZDLoadFailViewWithTitle:(NSString *)title topGap:(CGFloat)topGap{
    UIImageView * imageView = [XDSUtilities imageViewWithFrame:CGRectZero image:[UIImage imageNamed:@"ico_record_null"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(topGap);
        make.width.mas_equalTo(100.0);
        make.height.mas_equalTo(100.0);
    }];
    
    UILabel * label = [XDSUtilities labelWithFrame:CGRectZero
                                    textAlignment:NSTextAlignmentCenter
                                             font:[UIFont systemFontOfSize:18]
                                             text:title
                                        textColor:[UIColor colorWithRed:140.0f/255.0f green:140.0f/255.0f blue:140.0f/255.0f alpha:1.0f]];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).with.offset(20.0f);
        make.left.mas_equalTo(10.0f);
        make.height.mas_equalTo(20.0f);
    }];
    CGRect frame = self.frame;
    frame.size.height = 200 + topGap;
    self.frame = frame;
}


- (void)buttonClick:(UIButton *)button{
    if (_clickBlock) {
        _clickBlock();
    }
}

@end
