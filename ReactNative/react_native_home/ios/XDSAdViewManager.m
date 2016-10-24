//
//  XDSAdViewManager.m
//  react_native_home
//
//  Created by zhengda on 16/10/24.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "XDSAdViewManager.h"
#import "XDSAdView.h"

@implementation XDSAdViewManager

RCT_EXPORT_MODULE()
- (UIView *)view{
  return [[XDSAdView alloc] initWithFrame:CGRectMake(0, 0, 414, 200)];
}

@end
