//
//  INSArticleModel.h
//  iNews
//
//  Created by xudosom on 16/8/15.
//  Copyright © 2016年 zhengda. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    INSArticleCacheStatusNone = 0,
    INSArticleCacheStatusCached,
    INSArticleCacheStatusFailed
} INSArticleCacheStatus;
typedef enum {
    INSArticleReadStatusUnread,
    INSArticleReadStatusRead,
}INSArticleReadStatus;

@interface INSArticleModel : NSObject
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * summary;
@property (strong, nonatomic) NSString * href;
@property (strong, nonatomic) NSString * content;

@property (strong, nonatomic) NSString * articleType;
@property (strong, nonatomic) NSString * articleId;
@property (strong, nonatomic) NSString * publicDate;

@property (nonatomic, strong) NSNumber * cacheStatus;
@property (nonatomic, strong) NSNumber * read;

- (NSString *)toHtmlString;
@end
