//
//  XDSWebViewController.m

//  Created by zhengda on 15/10/20.
//  Copyright © 2015年 zhengda. All rights reserved.
//

#import "XDSWebViewController.h"
#import "XDSWebProgressView.h"

@interface XDSWebViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) XDSWebProgressView * webProgressView;


@end

@implementation XDSWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ocAdvertisingCampaignViewControllerDataInit];
    [self createOCAdvertisingCampaignViewControllerUI];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self backForwardAction];
}

#pragma mark - UI相关
- (void)createOCAdvertisingCampaignViewControllerUI{
    [self addBarButtonItem];
    [self createProgessBar];
    [self createWebView];
}
-(void)createProgessBar{
    CGFloat progressHeight = 2;
    CGRect frame = CGRectMake(0, 44-progressHeight, self.view.frame.size.width, progressHeight);
    XDSWebProgressView *pv = [[XDSWebProgressView alloc] initWithFrame:frame
                                                       progressHeight:progressHeight];
    self.webProgressView = pv;
    [self.navigationController.navigationBar addSubview:_webProgressView];

}
- (void)createWebView{
    self.webView.delegate = nil;
    self.webView = nil;
    self.webView = [[UIWebView alloc]initWithFrame:CGRectZero];
    _webView.delegate = self;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_webView];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self loadURL];
}

- (void)addBarButtonItem{
    if (self.navigationItem.leftBarButtonItems.count > 1) {
        return;
    }
    NSMutableArray * items = [NSMutableArray arrayWithCapacity:0];
    
    UIBarButtonItem * barButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ico_back"]
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(leftBarButtonItemClick:)];
    barButtonItem.tintColor = [UIColor brownColor];
    [items addObject:barButtonItem];
    
    if (_webView.canGoBack) {
        UIBarButtonItem * closeBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭"
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:self
                                                                              action:@selector(closeBarButtonItemClick:)];
        closeBarButtonItem.tintColor = [UIColor brownColor];
        [items addObject:closeBarButtonItem];
    }
    self.navigationItem.leftBarButtonItems = items;
}
#pragma mark - 代理方法
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    NSString *urlString = [[request URL] absoluteString];
    NSLog(@"urlString = %@", urlString);

    //在向服务端发送请求状态栏显示网络活动标志：
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.webProgressView shouldStartLoadWithRequestProgressAnimation];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self addBarButtonItem];
    [self.webProgressView webViewDidStartLoadProgressAnimation];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //请求结束状态栏隐藏网络活动标志：
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.webProgressView webViewDidFinishLoadProgressAnimation];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    //请求结束状态栏隐藏网络活动标志：
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.webProgressView webViewDidFinishLoadProgressAnimation];
    NSString * errorDescription = error.userInfo[@"NSLocalizedDescription"];
    if (errorDescription && errorDescription.length) {
        [XDSUtilities showHud:errorDescription rootView:self.view hideAfter:1.2];
    }
}

#pragma mark - 网络请求

#pragma mark - 点击事件处理
- (void)leftBarButtonItemClick:(UIBarButtonItem *)leftBarButtonItem{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [super popBack:leftBarButtonItem];
    }
}
- (void)closeBarButtonItemClick:(UIBarButtonItem *)closeBarButtonItem{
        [self popBack:closeBarButtonItem];
}

#pragma mark - 其他私有方法
- (void)backForwardAction{
    [self.webProgressView removeFromSuperview];
}


- (void)loadURL{
    NSString * requestURLString = _requestURL;
    NSURL * requestURL = [NSURL URLWithString:requestURLString];
    if (requestURL) {
        NSURLRequest *request = [NSURLRequest requestWithURL:requestURL
                                                 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                             timeoutInterval:60];
        [self.webView loadRequest:request ];
    }else{
        [XDSUtilities showHud:@"不合法的URL" rootView:self.navigationController.view hideAfter:1.2];
        [self.navigationController performSelector:@selector(popBack:) withObject:nil afterDelay:1.2];
    }
}

#pragma mark - 内存管理相关
- (void)ocAdvertisingCampaignViewControllerDataInit{

}

@end
