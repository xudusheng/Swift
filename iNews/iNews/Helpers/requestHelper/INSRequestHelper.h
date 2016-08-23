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
typedef void (^INSRequestHelperBlock) (id responseObject, NSError * error);

@interface INSRequestHelper : NSObject

- (void)fetchHomePage:(NSInteger)type page:(NSInteger)page complete:(INSRequestHelperBlock)complete;

- (void)fetchArticleDetail:(INSArticleModel *)article complete:(INSRequestHelperBlock)complete;

@end
