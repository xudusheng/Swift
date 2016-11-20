//
//  IHYMoviePlayButtonCell.m
//  iHappy
//
//  Created by xudosom on 2016/11/20.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import "IHYMoviePlayButtonCell.h"

@implementation IHYMoviePlayButtonCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createTitleLabel];
    }
    return self;
}


- (void)createTitleLabel{
    self.titleLabel = [XDSUtilities labelWithFrame:CGRectZero
                                     textAlignment:NSTextAlignmentCenter
                                              font:[UIFont systemFontOfSize:13]
                                              text:nil
                                         textColor:[UIColor colorWithHexString:@"#666666"]];
    [self.contentView addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}
@end
