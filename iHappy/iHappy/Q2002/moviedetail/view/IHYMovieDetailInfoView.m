//
//  IHYMovieDetailInfoView.m
//  iHappy
//
//  Created by xudosom on 2016/11/20.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import "IHYMovieDetailInfoView.h"
@implementation IHYMovieDetailInfoTitleAndContentModel
@end
@interface IHYMovieDetailInfoView()

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titleLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *contentLabels;
@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UILabel *sumaryLabel;

@end


@implementation IHYMovieDetailInfoView
- (void)dealloc{
    NSLog(@"%@ ==> dealloc", [self class]);
}
- (void)movieDetailInfoWithMovieImage:(NSString *)href
                               sumary:(NSString *)sumary
                titlaAndContentModels:(NSArray<IHYMovieDetailInfoTitleAndContentModel *> *)titlaAndContentModels {
    [_movieImageView sd_setImageWithURL:[NSURL URLWithString:href] placeholderImage:nil];
    _sumaryLabel.text = sumary;
    for (int i = 0; i < _titleLabels.count; i ++) {
        UILabel * titleLabel = _titleLabels[i];
        UILabel * contentLabel = _contentLabels[i];
        if (i < titlaAndContentModels.count) {
            IHYMovieDetailInfoTitleAndContentModel * model = titlaAndContentModels[i];
            titleLabel.text = model.title;
            contentLabel.text = model.content;
        }else{
            titleLabel.text = @"";
            contentLabel.text = @"";
        }
    }
}

@end
