//
//  CALayer+Addition.h
//  Laomoney
//
//  Created by zhengda on 9/6/15.
//  Copyright (c) 2015 zhengda. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Addition)

@property(nonatomic, strong) UIColor *borderColorFromUIColor;
- (void)setBorderColorFromUIColor:(UIColor *)color;

@end
