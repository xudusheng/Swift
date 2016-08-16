//
//  INSRequestHelper.m
//  iNews
//
//  Created by zhengda on 16/8/15.
//  Copyright © 2016年 zhengda. All rights reserved.
//

#import "INSRequestHelper.h"

@implementation INSRequestHelper

+ (void)fetchHomePage:(NSInteger)type page:(NSInteger)page{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString * rootUrl = @"http://www.wenzhaiwang.com";
    NSString * urlString = [NSString stringWithFormat:@"%@/%@/list_%ld_%ld.html",rootUrl, @"meiwenzhaichao", type, page];
    [manager GET:urlString
      parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {

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
//                        NSLog(@"title = %@", [[anElement elementsForName:@"a"].firstObject stringValue]);
//                        NSLog(@"href = %@", [[[anElement elementsForName:@"a"].firstObject attributeForName:@"href"] stringValue]);
//                        NSLog(@"content = %@", [[[anElement elementsForName:@"a"].lastObject elementsForName:@"p"].firstObject stringValue]);
                        GDataXMLElement * element_a = [anElement elementsForName:@"a"].firstObject;
                        GDataXMLElement * element_p = [[[anElement elementsForName:@"a"].lastObject elementsForName:@"p"]firstObject];
                        INSArticleModel * articleModel = [[INSArticleModel alloc]init];
                        articleModel.title = [element_a stringValue];
                        articleModel.href = [[element_a attributeForName:@"href"] stringValue];
                        articleModel.summary = [element_p stringValue];

//                        [[PRDatabase sharedDatabase] storeArticle:article];
                    }
                }
            });
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
 
}


@end
