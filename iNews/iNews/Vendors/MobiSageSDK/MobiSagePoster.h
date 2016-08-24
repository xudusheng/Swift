//
//  MobiSagePoster.h
//  ios_sdk
//
//  Created by xueli on 15/4/23.
//  Copyright (c) 2015年 fwang. All rights reserved.
//  

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MobiSagePosterAdSize) {
    
    MobiSagePosterAdSizeNormal,    // for iPhone 300*250 iPad 600*500
    MobiSagePosterAdSizeLarge,     // for iPhone 320*480 iPad 640*960
    
};

@class MobiSagePoster;

@protocol MobiSagePosterAdDelegate <NSObject>

@optional

/**
 *  adInterstitial被点击
 *  @param adInterstitial
 */
- (void)mobiSagePosterAdClick:(MobiSagePoster *)adInterstitial;

/**
 *  adInterstitial被关闭
 *  @param adInterstitial
 */
- (void)mobiSagePosterAdClose:(MobiSagePoster *)adInterstitial;

/**
 *  adInterstitial请求成功
 *  @param adInterstitial
 */
- (void)mobiSagePosterAdSuccessToRequest:(MobiSagePoster *)adInterstitial;

/**
 *  adInterstitial请求失败
 *  @param adInterstitial
 */
- (void)mobiSagePosterAdFaildToRequest:(MobiSagePoster *)adInterstitial withError:(NSError*) error;

@end

@interface MobiSagePoster : UIView

@property(nonatomic, assign) id<MobiSagePosterAdDelegate> delegate;

/**
 *  初始化并请求插屏广告
 *  @param adSize 广告视图大小
 *  @param delegate 该广告所使用的委托
 *  @param slotToken 插屏广告位id
 */
- (id)initInterstitialAdSize:(MobiSagePosterAdSize)adSize
                    delegate:(id<MobiSagePosterAdDelegate>)delegate
                   slotToken:(NSString *)slotToken;

/**
 *  展示插屏广告
 */
- (void)showInterstitialAd;

@end
