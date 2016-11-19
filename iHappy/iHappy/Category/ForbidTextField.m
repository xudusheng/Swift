//
//  ForbidTextField.m
//  Thumb
//
//  Created by ios on 14-12-8.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ForbidTextField.h"

@implementation ForbidTextField

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:) || action == @selector(cut:) || action == @selector(selectAll:) || action == @selector(copy:) || action == @selector(select:)) {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}


@end
