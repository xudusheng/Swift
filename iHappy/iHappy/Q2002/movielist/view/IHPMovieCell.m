//
//  IHPMovieCell.m
//  iHappy
//
//  Created by xudosom on 2016/11/19.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import "IHPMovieCell.h"
@interface IHPMovieCell()
    
    @property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
    @property (weak, nonatomic) IBOutlet UILabel *titleLabel;
    
    @end
    
@implementation IHPMovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

    - (void)cellWithMovieModel:(IHYMovieModel *)movieModel{
        if (!movieModel) {
            _movieImageView.image = nil;
            _titleLabel.text = @"";
        }else{
            [_movieImageView sd_setImageWithURL:[NSURL URLWithString:movieModel.imageurl] placeholderImage:nil];
            _titleLabel.text = movieModel.name;
        }
        
    }
    
@end
