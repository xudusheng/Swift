//
//  XDSInMobiAdViewManager.m
//  react_native_home
//
//  Created by zhengda on 16/10/24.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import "XDSInMobiAdViewManager.h"
#import "XDSInMobiAdView.h"
@implementation XDSInMobiAdViewManager

RCT_EXPORT_MODULE()

- (UIView *)view{
  CGFloat width = [UIScreen mainScreen].bounds.size.width;
  XDSInMobiAdView * adView =[[XDSInMobiAdView alloc]initWithFrame:CGRectMake(0, 0, width, 50)];
  return adView;
}

@end
