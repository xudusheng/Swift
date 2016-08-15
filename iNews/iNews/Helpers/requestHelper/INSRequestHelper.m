//
//  INSRequestHelper.m
//  iNews
//
//  Created by zhengda on 16/8/15.
//  Copyright © 2016年 zhengda. All rights reserved.
//

#import "INSRequestHelper.h"

@implementation INSRequestHelper

+ (void)fetchHomePage{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://www.wenzhaiwang.com/meiwenzhaichao/"
      parameters:nil
        progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
            NSString * result = [[NSString alloc]initWithData:responseObject encoding:enc];
            if (result.length) {
                
                GDataXMLDocument * doc= [[GDataXMLDocument alloc]initWithHTMLString:result error:nil];
                GDataXMLElement*rootEle= [doc rootElement];//获得root根节点
                NSArray * arr = [rootEle nodesForXPath:@"//div[@class=\"list-article\"]" error:nil];
                GDataXMLElement * ele = arr.firstObject;
                
                GDataXMLDocument * doc_1= [[GDataXMLDocument alloc]initWithHTMLString:ele.description error:nil];
                GDataXMLElement*rootEle_1= [doc_1 rootElement];//获得root根节点
                NSArray * arr_1 = [rootEle_1 nodesForXPath:@"//li" error:nil];
                NSLog(@"%@", arr_1);
                for (GDataXMLElement * element in arr_1) {
                    NSLog(@"element = %@", element.XMLString);
                    
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
        }];
 
}


@end
