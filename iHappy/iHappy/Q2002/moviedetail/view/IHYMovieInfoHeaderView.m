//
//  IHYMovieInfoHeaderView.m
//  iHappy
//
//  Created by xudosom on 2016/11/20.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import "IHYMovieInfoHeaderView.h"

@interface IHYMovieInfoHeaderView ()
@property (strong, nonatomic)  IHYMovieDetailInfoView * movieDetailInfoView ;
@end
@implementation IHYMovieInfoHeaderView
- (void)dealloc{
    NSLog(@"%@ ==> dealloc", [self class]);
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        self.movieDetailInfoView = [[NSBundle mainBundle]loadNibNamed:@"IHYMovieDetailInfoView" owner:self options:nil].firstObject;
//        CGRect infoViewFrame = frame;
//        infoViewFrame.origin.x = 0;
//        infoViewFrame.origin.y = 0;
//        _movieDetailInfoView.frame = infoViewFrame;
        [self addSubview:_movieDetailInfoView];
        [_movieDetailInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return self;
}


- (void)movieInfoHeaderWithMovieImage:(NSString *)href
                               sumary:(NSString *)sumary
                titlaAndContentModels:(NSArray<IHYMovieDetailInfoTitleAndContentModel *> *)titlaAndContentModels{
    [_movieDetailInfoView movieDetailInfoWithMovieImage:href
                                                 sumary:sumary
                                  titlaAndContentModels:titlaAndContentModels];
}
@end
