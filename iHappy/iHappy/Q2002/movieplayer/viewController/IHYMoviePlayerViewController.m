//
//  IHYMoviePlayerViewController.m
//  iHappy
//
//  Created by xudosom on 2016/11/20.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import "IHYMoviePlayerViewController.h"

@interface IHYMoviePlayerViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView * webView;
@end

@implementation IHYMoviePlayerViewController
- (void)dealloc{
    NSLog(@"%@ ==> dealloc", [self class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self moviePlayerViewControllerDataInit];
    [self createMoviePlayerViewControllerUI];
}


#pragma mark - UI相关
- (void)createMoviePlayerViewControllerUI{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectZero];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    
    [self fetchMoviePlayer];
}

#pragma mark - 网络请求
- (void)fetchMoviePlayer{
    
    __weak typeof(self)weakSelf = self;
    [[[XDSHttpRequest alloc] init] htmlRequestWithHref:_movieSrc
                                         hudController:self
                                               showHUD:YES
                                               HUDText:nil
                                         showFailedHUD:YES
                                               success:^(BOOL success, NSData * htmlData) {
//                                                   NSLog(@"%@", [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding]);
                                                   [weakSelf detailHtmlData:htmlData];
                                               } failed:^(NSString *errorDescription) {
                                                   
                                               }];
    
}
#pragma mark - 代理方法
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *string = [webView stringByEvaluatingJavaScriptFromString:@"sta()"];
    NSLog(@"string = %@", string);
}


#pragma mark - 点击事件处理

#pragma mark - 其他私有方法
- (void)detailHtmlData:(NSData *)htmlData{
    TFHpple * hpp = [[TFHpple alloc] initWithHTMLData:htmlData];
    TFHppleElement * iframe = [hpp searchWithXPathQuery:@"//iframe"].firstObject;
    if (iframe != nil) {
        NSString * playerSrc = [iframe objectForKey:@"src"];
        
        NSURL * url = [NSURL URLWithString:playerSrc];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
        __weak typeof(self)weakSelf = self;
        [[[XDSHttpRequest alloc] init] htmlRequestWithHref:playerSrc
                                             hudController:self
                                                   showHUD:YES
                                                   HUDText:nil
                                             showFailedHUD:YES
                                                   success:^(BOOL success, NSData * htmlData) {
                                                       NSLog(@"%@", [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding]);
//                                                       [weakSelf detailHtmlData:htmlData];
                      
                                                       
                                                   } failed:^(NSString *errorDescription) {
                                                       
                                                   }];
        
    }
}


#pragma mark - 内存管理相关
- (void)moviePlayerViewControllerDataInit{
    
}


@end
