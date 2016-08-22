//
//  INSRequestHelper.m
//  iNews
//
//  Created by zhengda on 16/8/15.
//  Copyright © 2016年 zhengda. All rights reserved.
//

#import "INSRequestHelper.h"

@implementation INSRequestHelper

- (void)fetchHomePage:(NSInteger)type page:(NSInteger)page complete:(INSRequestHelperBlock)complete{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * rootUrl = @"http://www.wenzhaiwang.com";
    NSString * urlString = [NSString stringWithFormat:@"%@/%@/list_%ld_%ld.html",rootUrl, @"meiwenzhaichao", type, page];
    [manager GET:urlString
      parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
            [self safelyCallback:complete error:nil];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
                NSString * result = [[NSString alloc]initWithData:responseObject encoding:enc];
                if (result.length) {
                    
                    GDataXMLDocument * doc= [[GDataXMLDocument alloc]initWithHTMLString:result error:nil];
                    GDataXMLElement*rootEle= [doc rootElement];//获得root根节点
                    NSArray * arr = [rootEle nodesForXPath:@"//div[@class=\"list-article\"]" error:nil];
                    GDataXMLElement * element_article = arr.firstObject;
                    
                    GDataXMLElement * element_article_ul = [element_article elementsForName:@"ul"].firstObject;
                    NSArray * articles = [element_article_ul elementsForName:@"li"];
                    for (GDataXMLElement * anElement in articles) {
                        GDataXMLElement * element_a = [anElement elementsForName:@"a"].firstObject;
                        GDataXMLElement * element_p = [[[anElement elementsForName:@"a"].lastObject elementsForName:@"p"]firstObject];
                        GDataXMLElement * element_small = [anElement elementsForName:@"small"].firstObject;
                        INSArticleModel * articleModel = [[INSArticleModel alloc]init];
                        articleModel.title = [element_a stringValue];
                        articleModel.href = [[element_a attributeForName:@"href"] stringValue];
                        articleModel.summary = [element_p stringValue];

                        NSString *articleId = [[articleModel.href componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                        NSString * articleType = [[articleModel.href componentsSeparatedByString:@"/"] objectAtIndex:1];
                        NSString * publicDate = [[[element_small stringValue] componentsSeparatedByString:@" "]lastObject];
                        articleModel.articleType = articleType;
                        articleModel.articleId = articleId;
                        articleModel.publicDate = publicDate;
                        [[INSDataBase shareInstance] storeArticle:articleModel];
                    }
                }
                [self safelyCallback:complete error:nil];

            });
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        [self safelyCallback:complete error:error];
        }];
 
}

- (void)safelyCallback:(INSRequestHelperBlock)block error:(NSError *)error{
    if (!block) {
        return;
    }
    
    if (error) {
        if (error.code == NSURLErrorCancelled) {
            return;
        }
    }
    __weak typeof(self)weakSelf = self;
    if ([NSThread isMainThread]) {
        block(weakSelf, error);
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        block(weakSelf, error);
    });
}

@end
