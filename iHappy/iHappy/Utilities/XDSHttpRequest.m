//
//  XDSHttpRequest.m
//  Jurongbao
//
//  Created by wangrongchao on 15/11/14.
//  Copyright © 2015年 truly. All rights reserved.
//

#import "XDSHttpRequest.h"

@interface XDSHttpRequest()
@property (strong, nonatomic) NSURLSessionDataTask * sessionDataTask;
@property (weak, nonatomic) UIViewController * hudController;
@end

@implementation XDSHttpRequest
#pragma mark 网络请求的错误信息显示
NSString *const kConnectWebFailed = @"无法连接网络，请连接网络重试";//网络连接失败
NSString *const kAnalysisFailed = @"数据解析出错";//数据解析出错
NSString *const kLoadFailed = @"网络请求异常，请稍后重试"; //请求失败
NSString *const kTimeCallOut = @"网络请求超时，请稍后重试";//链接超时

NSString *const key = @"huidaibao";

- (void)GETWithURLString:(NSString *)urlString
                reqParam:(NSDictionary *)reqParam
           hudController:(UIViewController *)hudController
                 showHUD:(BOOL)showHUD
                 HUDText:(NSString *)HUDText
           showFailedHUD:(BOOL)showFailedHUD
                 success:(void(^)(BOOL success, NSDictionary * successResult))success
                  failed:(void(^)(NSString * errorDescription))failed{
    if (![self isWebAvailible]) {
        failed(kConnectWebFailed);
        [self showFailedHUD:showFailedHUD Failed:kConnectWebFailed rootView:hudController.view];
        return;
    }
    
    
    if (showHUD) {//显示HUD
        [XDSUtilities showHud:hudController.view text:HUDText];
        self.hudController = hudController;
    }
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//使用这个将得到的是JSON

    [manager.requestSerializer setValue:@"40623ab568c9f719af56d75a499926b0" forHTTPHeaderField:@"X-Bmob-Application-Id"];
    [manager.requestSerializer setValue:@"b02905ffe9915574dc16200df988aa80" forHTTPHeaderField:@"X-Bmob-REST-API-Key"];
    
    self.sessionDataTask = [manager GET:urlString parameters:reqParam?reqParam:@{}
                                                      progress:^(NSProgress * _Nonnull downloadProgress) {
                                                          
                                                      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                          NSLog(@" ============ %@", responseObject);
                                                          [XDSUtilities hideHud:hudController.view];
                                                          id result = responseObject;
                                                          if (result && [result isKindOfClass:[NSDictionary class]]) {
                                                              NSString * error_code = [XDSUtilities stringFromidString:result[@"error_code"]];
                                                              NSDictionary * successResult = result[@"result"];
                                                              NSString * reason = [XDSUtilities stringFromidString:result[@"reason"]];
                                                              if ([error_code isEqualToString:@"0"]) {
                                                                  success(YES, successResult);
                                                              }else{
                                                                  [self showFailedHUD:showFailedHUD Failed:reason rootView:hudController.view];
                                                                  failed(reason);
                                                              }
                                                          }else{
                                                              [self showFailedHUD:showFailedHUD Failed:kAnalysisFailed rootView:hudController.view];
                                                              failed(kAnalysisFailed);
                                                          }
                                                          
                                                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                          
                                                          [XDSUtilities hideHud:hudController.view];
                                                          NSString *errorDetail = [error localizedDescription];
                                                          NSLog(@"error = %@", errorDetail);
                                                          NSRange range_0 = [errorDetail rangeOfString:@"The request timed out."];
                                                          NSRange range_1 = [errorDetail rangeOfString:@"请求超时"];
                                                          if (range_0.location != NSNotFound || range_1.location != NSNotFound) {
                                                              [self showFailedHUD:showFailedHUD Failed:kTimeCallOut rootView:hudController.view];
                                                              errorDetail = kTimeCallOut;
                                                          }else{
                                                              [self showFailedHUD:showFailedHUD Failed:kLoadFailed rootView:hudController.view];
                                                              errorDetail = kLoadFailed;
                                                          }
                                                          
                                                          failed(errorDetail);
                                                          
                                                      }];
    
    [_sessionDataTask resume];
}



- (void)htmlRequestWithHref:(NSString *)htmlHref
              hudController:(UIViewController *)hudController
                    showHUD:(BOOL)showHUD
                    HUDText:(NSString *)HUDText
              showFailedHUD:(BOOL)showFailedHUD
                    success:(void(^)(BOOL success, NSData * htmlString))success
                     failed:(void(^)(NSString * errorDescription))failed{
    
    if (htmlHref && ! [htmlHref hasPrefix:@"http"]) {
        NSString * rootHref = @"http://www.q2002.com";
        if (![htmlHref hasPrefix:@"/"]) {
            rootHref = [rootHref stringByAppendingString:@"/"];
        }
        htmlHref = [rootHref stringByAppendingString:htmlHref];
    }
    
    if (![self isWebAvailible]) {
        failed(kConnectWebFailed);
        [self showFailedHUD:showFailedHUD Failed:kConnectWebFailed rootView:hudController.view];
        return;
    }
    
    
    if (showHUD) {//显示HUD
        [XDSUtilities showHud:hudController.view text:HUDText];
        self.hudController = hudController;
    }

    htmlHref = [htmlHref stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//使用这个将得到的是NSData
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];//使用这个将得到的是JSON
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    
    
    self.sessionDataTask = [manager GET:htmlHref parameters:@{}
                               progress:^(NSProgress * _Nonnull downloadProgress) {
                                   
                               } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                   responseObject = [self replaceNoUtf8:responseObject];

                                   [XDSUtilities hideHud:hudController.view];
                                   if (responseObject && success) {
                                       success(YES, responseObject);
                                   }
                                   
                                   
                               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                   
                                   [XDSUtilities hideHud:hudController.view];
                                   NSString *errorDetail = [error localizedDescription];
                                   NSLog(@"error = %@", errorDetail);
                                   NSRange range_0 = [errorDetail rangeOfString:@"The request timed out."];
                                   NSRange range_1 = [errorDetail rangeOfString:@"请求超时"];
                                   if (range_0.location != NSNotFound || range_1.location != NSNotFound) {
                                       [self showFailedHUD:showFailedHUD Failed:kTimeCallOut rootView:hudController.view];
                                       errorDetail = kTimeCallOut;
                                   }else{
                                       [self showFailedHUD:showFailedHUD Failed:kLoadFailed rootView:hudController.view];
                                       errorDetail = kLoadFailed;
                                   }
                                   
                                   failed(errorDetail);
                                   
                               }];
    
    [_sessionDataTask resume];
    
    
    
}

- (void)showFailedHUD:(BOOL)showFailedHUD Failed:(NSString *)failed rootView:(UIView *)rootView{
    if (showFailedHUD && rootView) {
        UIWindow * window = [UIApplication sharedApplication].delegate.window;
        [XDSUtilities showHudFailed:failed rootView:window imageName:nil];
    }
}


#pragma mark - 取消请求
- (void)cancelRequest{
    if (_hudController) {
        [XDSUtilities hideHud:_hudController.view];
    }
    if (_sessionDataTask && _sessionDataTask.state == NSURLSessionTaskStateRunning) {
        [_sessionDataTask cancel];
    }
}


- (BOOL)isWebAvailible{//判断网络是否可用
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    switch ([reach currentReachabilityStatus]){
        case NotReachable:return NO; break;
        case ReachableViaWiFi: return YES;break;
        default: return YES;
    }
    return YES;
}




//替换非utf8字符
//注意：如果是三字节utf-8，第二字节错误，则先替换第一字节内容(认为此字节误码为三字节utf8的头)，然后判断剩下的两个字节是否非法；
- (NSData *)replaceNoUtf8:(NSData *)data
{
    char aa[] = {'A','A','A','A','A','A'};                      //utf8最多6个字符，当前方法未使用
    NSMutableData *md = [NSMutableData dataWithData:data];
    int loc = 0;
    while(loc < [md length])
    {
        char buffer;
        [md getBytes:&buffer range:NSMakeRange(loc, 1)];
        if((buffer & 0x80) == 0)
        {
            loc++;
            continue;
        }
        else if((buffer & 0xE0) == 0xC0)
        {
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80)
            {
                loc++;
                continue;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else if((buffer & 0xF0) == 0xE0)
        {
            loc++;
            [md getBytes:&buffer range:NSMakeRange(loc, 1)];
            if((buffer & 0xC0) == 0x80)
            {
                loc++;
                [md getBytes:&buffer range:NSMakeRange(loc, 1)];
                if((buffer & 0xC0) == 0x80)
                {
                    loc++;
                    continue;
                }
                loc--;
            }
            loc--;
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
        else
        {
            //非法字符，将这个字符（一个byte）替换为A
            [md replaceBytesInRange:NSMakeRange(loc, 1) withBytes:aa length:1];
            loc++;
            continue;
        }
    }
    
    return md;
}







- (void)queryInitialInfoWithUrlString:(NSString *)urlString
                reqParam:(NSDictionary *)reqParam
           hudController:(UIViewController *)hudController
                 showHUD:(BOOL)showHUD
                 HUDText:(NSString *)HUDText
           showFailedHUD:(BOOL)showFailedHUD
                 success:(void(^)(BOOL success, NSDictionary * successResult))success
                  failed:(void(^)(NSString * errorDescription))failed{
    if (![self isWebAvailible]) {
        failed(kConnectWebFailed);
        [self showFailedHUD:showFailedHUD Failed:kConnectWebFailed rootView:hudController.view];
        return;
    }
    
    
    if (showHUD) {//显示HUD
        [XDSUtilities showHud:hudController.view text:HUDText];
        self.hudController = hudController;
    }
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];//使用这个将得到的是JSON
    
    [manager.requestSerializer setValue:@"40623ab568c9f719af56d75a499926b0" forHTTPHeaderField:@"X-Bmob-Application-Id"];
    [manager.requestSerializer setValue:@"b02905ffe9915574dc16200df988aa80" forHTTPHeaderField:@"X-Bmob-REST-API-Key"];
    
    self.sessionDataTask = [manager GET:urlString parameters:reqParam?reqParam:@{}
                               progress:^(NSProgress * _Nonnull downloadProgress) {
                                   
                               } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                   NSLog(@" ============ %@", responseObject);
                                   [XDSUtilities hideHud:hudController.view];
                                   id result = responseObject;
                                   if (result && [result isKindOfClass:[NSDictionary class]]) {
                                       NSString * error_code = [XDSUtilities stringFromidString:result[@"error_code"]];
                                       if ([error_code isEqualToString:@""]) {
                                           success(YES, result);
                                       }else{
                                           [self showFailedHUD:showFailedHUD Failed:@"初始化数据请求失败" rootView:hudController.view];
                                           failed(@"初始化数据请求失败");
                                       }
                                   }else{
                                       [self showFailedHUD:showFailedHUD Failed:kAnalysisFailed rootView:hudController.view];
                                       failed(kAnalysisFailed);
                                   }
                                   
                               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                   
                                   [XDSUtilities hideHud:hudController.view];
                                   NSString *errorDetail = [error localizedDescription];
                                   NSLog(@"error = %@", errorDetail);
                                   NSRange range_0 = [errorDetail rangeOfString:@"The request timed out."];
                                   NSRange range_1 = [errorDetail rangeOfString:@"请求超时"];
                                   if (range_0.location != NSNotFound || range_1.location != NSNotFound) {
                                       [self showFailedHUD:showFailedHUD Failed:kTimeCallOut rootView:hudController.view];
                                       errorDetail = kTimeCallOut;
                                   }else{
                                       [self showFailedHUD:showFailedHUD Failed:kLoadFailed rootView:hudController.view];
                                       errorDetail = kLoadFailed;
                                   }
                                   
                                   failed(errorDetail);
                                   
                               }];
    
    [_sessionDataTask resume];
}
@end
