//
//  IHYNewsListCell.m
//  iHappy
//
//  Created by zhengda on 16/11/21.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import "IHYNewsListCell.h"
@interface IHYNewsListCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end
@implementation IHYNewsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)dealloc{
    NSLog(@"%@ ==> dealloc", [self class]);
}


- (void)cellWithNewsModel:(IHYNewsModel *)newsModel{
    _titleLabel.text = newsModel.title;
    _dateLabel.text = newsModel.date;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:newsModel.thumbnail_pic_s] placeholderImage:nil];
    
}

@end
