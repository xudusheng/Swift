//
//  XDSInMobiAdView.h
//  Ad_Demo
//
//  Created by zhengda on 16/10/24.
//  Copyright © 2016年 zhengda. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^bannerDidFinishLoadingBlock)();
@interface XDSInMobiAdView : UIView

@property (copy, nonatomic)bannerDidFinishLoadingBlock bannerDidFinishLoadingBlock;
@end
