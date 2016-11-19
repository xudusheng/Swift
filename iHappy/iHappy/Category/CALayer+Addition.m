//
//  CALayer+Addition.m
//  Laomoney
//
//  Created by zhengda on 9/6/15.
//  Copyright (c) 2015 zhengda. All rights reserved.
//

#import "CALayer+Addition.h"
#import <objc/runtime.h>

@implementation CALayer (Addition)
- (UIColor *)borderColorFromUIColor {
    return objc_getAssociatedObject(self, @selector(borderColorFromUIColor));
}

-(void)setBorderColorFromUIColor:(UIColor *)color
{
    objc_setAssociatedObject(self, @selector(borderColorFromUIColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setBorderColorFromUI:color];
}
- (void)setBorderColorFromUI:(UIColor *)color
{
    self.borderColor = color.CGColor;
    //    NSLog(@"%@", color);
}
@end
