//
//  MobiSageBanner
//  ios_sdk
//
//  Created by xueli on 15/5/5.
//  Copyright (c) 2015年 fwang. All rights reserved.
//

typedef NS_ENUM(NSInteger, MobiSageBannerAdSize) {
    
    MobiSageBannerAdSizeNormal,  //for iPhone 320X50  iPhone6 375*50 iPhone6 Plus 414*50  iPad 728X90
    MobiSageBannerAdSizeLarge,   //for iPhone 320X50  iPhone6 375*58 iPhone6 Plus 414*64  iPad 728X90
    
};

typedef NS_ENUM(NSInteger, MobiSageBannerAdRefreshTime) {
    
    MobiSageBannerAdRefreshTimeNone,         //不刷新
    MobiSageBannerAdRefreshTimeHalfMinute,   //30秒刷新
    MobiSageBannerAdRefreshTimeOneMinute,    //60秒刷新
    
};

typedef NS_ENUM(NSInteger, MobiSageBannerAdAnimationType) {
    
    MobiSageBannerAdAnimationTypeNone    = -1,   //无动画
    MobiSageBannerAdAnimationTypeRandom  = 1,    //随机动画
    MobiSageBannerAdAnimationTypeFade    = 2,    //渐隐渐现
    MobiSageBannerAdAnimationTypeCubeT2B = 3,    //立体翻转从左到右
    MobiSageBannerAdAnimationTypeCubeL2R = 4,    //立体翻转从上到下
    
};

@class MobiSageBanner;

@protocol MobiSageBannerAdDelegate <NSObject>

@optional
/**
 *  adBanner被点击
 *  @param adBanner
 */
- (void)mobiSageBannerAdClick:(MobiSageBanner*)adBanner;

/**
 *  adBanner请求成功并展示广告
 *  @param adBanner
 */
- (void)mobiSageBannerAdSuccessToShowAd:(MobiSageBanner*)adBanner;

/**
 *  adBanner请求失败
 *  @param adBanner
 */
- (void)mobiSageBannerAdFaildToShowAd:(MobiSageBanner*)adBanner withError:(NSError*) error;

/**
 *  adBanner被点击后弹出LandingPage
 *  @param adBanner
 */
- (void)mobiSageBannerLandingPageShowed:(MobiSageBanner*)adBanner;

/**
 *  adBanner弹出的LandingPage被关闭
 *  @param adBanner
 */
- (void)mobiSageBannerLandingPageHided:(MobiSageBanner*)adBanner;
@end

@interface MobiSageBanner : UIView

@property(nonatomic, assign) id<MobiSageBannerAdDelegate> delegate;

/**
 *  初始化并请求横幅广告
 *  @param adSize 广告视图大小
 *  @param delegate 该广告所使用的委托
 *  @param slotToken 横幅广告位id
 */
- (id)initBannerAdSize:(MobiSageBannerAdSize)adSize
              delegate:(id<MobiSageBannerAdDelegate>)delegate
             slotToken:(NSString *)slotToken;
/**
 *  设置广告刷新间隔时间
 *  @param refreshTime 广告刷新间隔时间，单位是“秒”
 */
- (void)setBannerAdRefreshTime:(MobiSageBannerAdRefreshTime)refreshTime;

/**
 *  设置多个广告之间过渡（切换）效果
 *  @param animationType	多个广告之间过渡（切换）效果
 */
- (void)setBannerAdAnimeType:(MobiSageBannerAdAnimationType)animationType;


@end
