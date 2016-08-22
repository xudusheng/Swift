//
//  INSRequestHelper.h
//  iNews
//
//  Created by zhengda on 16/8/15.
//  Copyright © 2016年 zhengda. All rights reserved.
//

#import <Foundation/Foundation.h>
@class INSRequestHelper;
typedef void (^INSRequestHelperBlock) (INSRequestHelper * fetcher, NSError *error);

@interface INSRequestHelper : NSObject

- (void)fetchHomePage:(NSInteger)type page:(NSInteger)page complete:(INSRequestHelperBlock)complete;
@end
