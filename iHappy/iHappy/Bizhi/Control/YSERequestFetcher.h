//
//  YSERequestFetcher.h
//  iHappy
//
//  Created by dusheng.xu on 2017/5/13.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YSEClassifyModel;
@class YSERequestFetcher;

UIKIT_EXTERN NSString *const kBiZhiCategoryListKey;
UIKIT_EXTERN NSString *const kBiZhiColorListKey;
UIKIT_EXTERN NSString *const kBiZhiImageListKey;
UIKIT_EXTERN NSString *const kBiZhiNextPageHrefKey;
UIKIT_EXTERN NSString *const kBiZhiIsLastPageKey;

typedef void(^CompleteType)(YSERequestFetcher *requestFetcher, NSDictionary *responseObj, NSError *error);

@interface YSERequestFetcher : NSObject

- (void)p_fetchHomePage:(NSString *)url complete:(CompleteType)complete;

@end
