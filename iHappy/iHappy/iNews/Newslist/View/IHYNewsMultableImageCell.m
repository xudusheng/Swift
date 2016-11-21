//
//  IHYNewsMultableImageCell.m
//  iHappy
//
//  Created by zhengda on 16/11/21.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import "IHYNewsMultableImageCell.h"
@interface IHYNewsMultableImageCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *autherLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *icon1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *icon2ImageView;

@end
@implementation IHYNewsMultableImageCell
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)cellWithNewsModel:(IHYNewsModel *)newsModel{
    _titleLabel.text = newsModel.title;
    _dateLabel.text = newsModel.date;
    _autherLabel.text = newsModel.author_name;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:newsModel.thumbnail_pic_s] placeholderImage:nil];
    [_icon1ImageView sd_setImageWithURL:[NSURL URLWithString:newsModel.thumbnail_pic_s02] placeholderImage:nil];
    [_icon2ImageView sd_setImageWithURL:[NSURL URLWithString:newsModel.thumbnail_pic_s03] placeholderImage:nil];

}
@end
