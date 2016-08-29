//
//  INSRequestHelper.h
//  iNews
//
//  Created by zhengda on 16/8/15.
//  Copyright © 2016年 zhengda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWHTTPFetcher.h"
@class INSRequestHelper;
typedef void (^INSRequestHelperBlock) (INSRequestHelper * requestHelper);

@interface INSRequestHelper : NSObject
@property (nonatomic, strong) id respObject;
@property (nonatomic, strong) NSError *error;

- (NSURLSessionDataTask *)fetchHomePage:(NSInteger)type page:(NSInteger)page complete:(INSRequestHelperBlock)complete;

- (NSURLSessionDataTask *)fetchArticleDetail:(INSArticleModel *)article complete:(INSRequestHelperBlock)complete;

@end
