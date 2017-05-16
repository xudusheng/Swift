//
//  YSERequestFetcher.m
//  iHappy
//
//  Created by dusheng.xu on 2017/5/13.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import "YSERequestFetcher.h"
#import "YSEClassifyModel.h"
#import "YSECategoryModel.h"
#import "YSEColorModel.h"
#import "YSEImageModel.h"
@interface YSERequestFetcher ()

@property (strong, nonatomic) NSDictionary *responseObj;
@property (strong, nonatomic) NSError *error;

@end

@implementation YSERequestFetcher

NSString *const kBiZhiCategoryListKey = @"categoryList";
NSString *const kBiZhiColorListKey = @"colorList";
NSString *const kBiZhiImageListKey = @"imageList";
NSString *const kBiZhiNextPageHrefKey = @"nextPageHref";
NSString *const kBiZhiIsLastPageKey = @"isLastPage";

- (void)p_fetchHomePage:(NSString *)url complete:(CompleteType)complete{
   
//    url = url.cw_URLEncodedString;
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            TFHpple *hptts = [[TFHpple alloc] initWithHTMLData:[result dataUsingEncoding:NSUTF8StringEncoding] ];
            NSMutableArray *categoryList = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *colorList = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *imageList = [NSMutableArray arrayWithCapacity:0];
            
            NSArray *categoryItems = [hptts searchWithXPathQuery:@"//div[@class=\"options eS hidden\"]//a[@class=\"bt\"]"];
            for (TFHppleElement *element in categoryItems) {
                NSString *name = [element text];
                if ([name isEqualToString:@"动漫"] || [name isEqualToString:@"卡通"]){
                    continue;
                }
                YSECategoryModel *aModel = [[YSECategoryModel alloc] init];
                NSString *href = [element objectForKey:@"href"];
                [aModel p_setName:name href:href];
                [categoryList addObject:aModel];
            }
            
            NSArray *colorItems = [hptts searchWithXPathQuery:@"//div[@class=\"options eS hidden\"]//a[contains(@class, 'btcolor color')]"];//模糊匹配
            for (TFHppleElement *colorElement in colorItems){
                NSString *name = [colorElement text];
                NSString *href = [colorElement objectForKey:@"href"];
                YSEColorModel *colorModel = [[YSEColorModel alloc] init];
                [colorModel p_setName:name href:href];
                [colorList addObject:colorModel];
            }
            
            NSArray *imgItems = [hptts searchWithXPathQuery:@"//li[@class=\"ty-imgcont\"]//img"];//模糊匹配
            for (TFHppleElement *imgElement in imgItems){
                NSString *name = [imgElement text];
                NSString *href = [imgElement objectForKey:@"src"];
                NSString *width = [imgElement objectForKey:@"width"];
                NSString *height = [imgElement objectForKey:@"height"];

                YSEImageModel *imageModel = [[YSEImageModel alloc] init];
                [imageModel p_setTitle:name href:href width:width height:height];
                [imageList addObject:imageModel];
            }
            
            NSString *xpath_a = @"//div[@id=\"pageNum\"]//span//a";
            NSString *xpath_span = @"//div[@id=\"pageNum\"]//span//span";
            
            NSString *query = [NSString stringWithFormat:@"%@ | %@", xpath_a, xpath_span];
            NSArray *pageNumItems = [hptts searchWithXPathQuery:query];
            
            NSString *nextHref = @"";
            BOOL isLastPage = YES;
            if (pageNumItems.count > 0) {
                TFHppleElement *lastPageElement = pageNumItems.lastObject;
                nextHref = [lastPageElement objectForKey:@"href"];
                
                TFHppleElement *spanElement = pageNumItems[pageNumItems.count-2];
                isLastPage = [spanElement.tagName isEqualToString:@"span"];
            }
            
            NSDictionary *responseData = @{
                                           kBiZhiCategoryListKey:categoryList,
                                           kBiZhiColorListKey:colorList,
                                           kBiZhiImageListKey:imageList,
                                           kBiZhiNextPageHrefKey:nextHref,
                                           kBiZhiIsLastPageKey:@(isLastPage),
                                           };
            self.responseObj = responseData;
            [self safelyCallback:complete error:nil];
            
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self safelyCallback:complete error:error];
    }];
}


- (void)safelyCallback:(CompleteType)complete error:(NSError *)error{
    self.error = error;
    if ([NSThread isMainThread]) {
        complete(self, self.responseObj, self.error);
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        complete(self, self.responseObj, self.error);
    });
}

@end
