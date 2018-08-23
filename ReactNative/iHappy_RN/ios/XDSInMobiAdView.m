//
//  XDSInMobiAdView.m
//  Ad_Demo
//
//  Created by zhengda on 16/10/24.
//  Copyright © 2016年 zhengda. All rights reserved.
//

#import "XDSInMobiAdView.h"
#import <InMobiSDK/IMBanner.h>

@interface XDSInMobiAdView()<IMBannerDelegate>
@property(assign, nonatomic)CGRect finalFrame;
@end

@implementation XDSInMobiAdView

- (instancetype)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    self.finalFrame = frame;
    self.clipsToBounds = YES;
    [self loadIMBanner];
  }
  return self;
}


//TODO:IMBanner
- (void)loadIMBanner{
  self.backgroundColor = [UIColor redColor];
  long long placementId = 1478274661195;
  IMBanner * banner = [[IMBanner alloc]initWithFrame:CGRectMake(0, 0, self.finalFrame.size.width, self.finalFrame.size.height)
                                         placementId: placementId
                                            delegate: self];
  banner.backgroundColor = [UIColor yellowColor];
  [self addSubview:banner];
  [banner load];
}



//IMBannerDelegate
-(void)bannerDidFinishLoading:(IMBanner*)banner{
  NSLog(@"--------------------------------------------------------%s", __FUNCTION__);
}

-(void)banner:(IMBanner*)banner didFailToLoadWithError:(IMRequestStatus*)error{
  NSLog(@"--------------------------------------------------------%s == %@", __FUNCTION__, error);
}
-(void)banner:(IMBanner*)banner didInteractWithParams:(NSDictionary*)params{
  NSLog(@"--------------------------------------------------------%s", __FUNCTION__);
}
-(void)userWillLeaveApplicationFromBanner:(IMBanner*)banner{
  NSLog(@"--------------------------------------------------------%s", __FUNCTION__);
}
-(void)bannerWillPresentScreen:(IMBanner*)banner{
  NSLog(@"--------------------------------------------------------%s", __FUNCTION__);
}
-(void)bannerDidPresentScreen:(IMBanner*)banner{
  NSLog(@"--------------------------------------------------------%s", __FUNCTION__);
}
-(void)bannerWillDismissScreen:(IMBanner*)banner{
  NSLog(@"--------------------------------------------------------%s", __FUNCTION__);
}
- (void)bannerDidDismissScreen:(IMBanner*)banner{
  NSLog(@"--------------------------------------------------------%s", __FUNCTION__);
}
-(void)banner:(IMBanner*)banner rewardActionCompletedWithRewards:(NSDictionary*)rewards{
  NSLog(@"--------------------------------------------------------%s", __FUNCTION__);
}



@end
