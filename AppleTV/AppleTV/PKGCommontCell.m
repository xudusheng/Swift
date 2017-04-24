//
//  PKGCommontCell.m
//  AppleTV
//
//  Created by Hmily on 2017/4/24.
//  Copyright © 2017年 Hmily. All rights reserved.
//

#import "PKGCommontCell.h"


@interface PKGCommontCell ()

@property (weak, nonatomic) IBOutlet UIView *infoContentView;
@property (weak, nonatomic) IBOutlet UIView *clockContentView;

@end
@implementation PKGCommontCell
- (void)awakeFromNib{
    [super awakeFromNib];
    
    self->_imageView.backgroundColor = [UIColor redColor];
    self->_infoContentView.backgroundColor = [UIColor whiteColor];
    self->_clockContentView.hidden = YES;
    
}
@end
