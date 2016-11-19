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
    NSString *const kLoadFailed = @"请求失败，请稍后重试"; //请求失败
    NSString *const kTimeCallOut = @"网络链接超时，请稍后重试";//链接超时
    
    NSString *const key = @"huidaibao";
    
- (void)GETWithURLString:(NSString *)urlString
                reqParam:(NSDictionary *)reqParam
           hudController:(UIViewController *)hudController
                 showHUD:(BOOL)showHUD
                 HUDText:(NSString *)HUDText
           showFailedHUD:(BOOL)showFailedHUD
                 success:(void(^)(NSDictionary * successResult, NSInteger status, NSString * tipMsg))success
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
    
    self.sessionDataTask = [[AFHTTPSessionManager manager] GET:urlString parameters:reqParam?reqParam:@{}
                                                      progress:^(NSProgress * _Nonnull downloadProgress) {
                                                          
                                                      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                          NSLog(@" ============ %@", responseObject);
                                                          [XDSUtilities hideHud:hudController.view];
                                                          //                                                          id result = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
                                                          //                                                          if (result && [result isKindOfClass:[NSDictionary class]]) {
                                                          //                                                              NSString * systemStatus = [XDSUtilities stringFromidString:result[@"systemStatus"]];
                                                          //                                                              NSDictionary * successResult = result[@"result"];
                                                          //                                                              NSInteger status = [result[@"status"] integerValue];
                                                          //                                                              NSString * tipMsg = [XDSUtilities stringFromidString:result[@"tipMsg"]];
                                                          //                                                              if ([systemStatus isEqualToString:@"1000"]) {
                                                          //                                                                  success(successResult, status, tipMsg);
                                                          //                                                              }else{
                                                          //#warning 处理系统级别的错误信息
                                                          //                                                                  [self showFailedHUD:showFailedHUD Failed:tipMsg rootView:hudController.view];
                                                          //                                                                  failed(tipMsg);
                                                          //                                                              }
                                                          //                                                          }else{
                                                          //                                                              [self showFailedHUD:showFailedHUD Failed:kAnalysisFailed rootView:hudController.view];
                                                          //                                                              failed(kAnalysisFailed);
                                                          //                                                          }
                                                          
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
    
    if (![self isWebAvailible]) {
        failed(kConnectWebFailed);
        [self showFailedHUD:showFailedHUD Failed:kConnectWebFailed rootView:hudController.view];
        return;
    }
    
    
    if (showHUD) {//显示HUD
        [XDSUtilities showHud:hudController.view text:HUDText];
        self.hudController = hudController;
    }
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSString* url = [htmlHref stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//        NSString* xml = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
//        
//        NSError * error = nil;
//        NSData * xmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:NSDataReadingMappedIfSafe error:&error];
//        if (!error) {
//            NSLog(@" ============ %@", [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding]);
//        }else{
//            NSLog(@"error = %@", error);
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [XDSUtilities hideHud:hudController.view];
//
//        });
//    });
//
//    return;

    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];//使用这个将得到的是NSData
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];//使用这个将得到的是JSON
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];

    self.sessionDataTask = [manager GET:htmlHref parameters:@{}
                                                      progress:^(NSProgress * _Nonnull downloadProgress) {
                                                          
                                                      } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    if (showFailedHUD) {
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
    
    @end
