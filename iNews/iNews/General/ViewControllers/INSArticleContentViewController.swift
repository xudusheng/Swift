//
//  INSArticleContentViewController.swift
//  iNews
//
//  Created by zhengda on 16/8/23.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class INSArticleContentViewController: UIViewController, UIWebViewDelegate, UIScrollViewDelegate {
    
    let kStatusBarHeight : CGFloat = 20.0;
    let kToolbarHeight : CGFloat = 44.0;

    internal var article : INSArticleModel!;
    var webView : UIWebView!;
    var statusBarHeight : NSLayoutConstraint!;
    var toolbarBottomConstraint : NSLayoutConstraint!;
    var lastContentOffset : CGPoint = CGPointMake(0, 0);

    var bannerAd : UIView!;
    var toolBar : INSToolBar!;
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchBannerAd();
        self.articleContentViewControllerDataInit();
        self.createArticleContentViewControllerUI();
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        if UIApplication.sharedApplication().statusBarHidden {
            self.statusBarHeight.constant = 0
        }else{
            self.statusBarHeight.constant = kStatusBarHeight;
        }
        self.view.layoutIfNeeded();
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated);
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide);
    }
    
    
    
    //MARK: - UI相关
    func createArticleContentViewControllerUI(){
        self.view.backgroundColor = UIColor.whiteColor();
        self.webView = UIWebView(frame: CGRectZero);
        self.webView.translatesAutoresizingMaskIntoConstraints = false;
        self.webView.backgroundColor = UIColor.whiteColor();
        self.webView.delegate = self;
        self.webView.scrollView.delegate = self;
        self.view.addSubview(self.webView);
        
        let statusBarBackView = UIView(frame: CGRectZero);
        statusBarBackView.backgroundColor = UIColor.yellowColor();
        statusBarBackView.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(statusBarBackView);
        
        self.toolBar = INSToolBar(frame: CGRectMake(0, SWIFT_DEVICE_SCREEN_HEIGHT, SWIFT_DEVICE_SCREEN_WIDTH, kToolbarHeight));
        self.toolBar.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(self.toolBar);
        
        let viewsDict = ["webView":webView, "statusBarBackView":statusBarBackView, "toolBar":toolBar];
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: .AlignAllLeft, metrics: nil, views: viewsDict));
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[statusBarBackView]|", options: .AlignAllLeft, metrics: nil, views: viewsDict));
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[toolBar]|", options: .AlignAllLeft, metrics: nil, views: viewsDict));

        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[webView]|", options: .AlignAllLeft, metrics: nil, views: viewsDict));
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[statusBarBackView]", options: .AlignAllLeft, metrics: nil, views: viewsDict));
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[toolBar(==44)]", options: .AlignAllLeft, metrics: nil, views: viewsDict));
        
        self.statusBarHeight = NSLayoutConstraint(item: statusBarBackView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: kStatusBarHeight);
        self.toolbarBottomConstraint = NSLayoutConstraint(item: self.toolBar, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: kToolbarHeight);
        self.view.addConstraints([self.statusBarHeight, self.toolbarBottomConstraint]);
        var insets = self.webView.scrollView.contentInset;
        insets.top = kStatusBarHeight;
        self.webView.scrollView.contentInset = insets;

        self.toolBar.backButton?.addTarget(self, action: #selector(INSArticleContentViewController.backAction(_:)), forControlEvents: .TouchUpInside);
        self.toolBar.shareButton?.addTarget(self, action: #selector(INSArticleContentViewController.shareAction(_:)), forControlEvents: .TouchUpInside);
        self.toolBar.refreshButton?.addTarget(self, action: #selector(INSArticleContentViewController.refreshAction(_:)), forControlEvents: .TouchUpInside);
        self.fetchArticleDetail();
    }
    
    //MARK: - 代理方法
    //UIWebViewDelegate
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if (navigationType != .LinkClicked) {
            return true;
        }

        let browserVC = PRBrowserViewController();
        browserVC.request = request;
        self.stackController.pushViewController(browserVC, animated: true);
        return false;
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if (self.bannerAd != nil) {
            var contentSize = webView.scrollView.contentSize;
            var frame = self.bannerAd.frame;
            frame.origin.y = contentSize.height;
            self.bannerAd.frame = frame;
            webView.scrollView.addSubview(self.bannerAd);
            contentSize.height += CGRectGetHeight(self.bannerAd.frame);
            webView.scrollView.contentSize = contentSize;
        }
    }

    //UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let distance = scrollView.contentOffset.y - self.lastContentOffset.y;
        let contentOffset = scrollView.contentOffset;
        if (distance > 0 && contentOffset.y > 0) {
            // pull up
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .Slide);
            self.statusBarHeight.constant = 0;
            self.toolbarBottomConstraint.constant = kToolbarHeight;
            UIView.animateWithDuration(0.3, animations: {
                var insets = scrollView.scrollIndicatorInsets;
                insets.top = 0;
                insets.bottom = 0;
                scrollView.scrollIndicatorInsets = insets;
                self.view.layoutIfNeeded();
            });
        }
        else {
            // pull down              
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide);
            self.statusBarHeight.constant = self.kStatusBarHeight;
            self.toolbarBottomConstraint.constant = 0;
            UIView.animateWithDuration(0.3, animations: {
                var insets = scrollView.scrollIndicatorInsets;
                insets.top = self.kStatusBarHeight;
                insets.bottom = self.kToolbarHeight;
                scrollView.scrollIndicatorInsets = insets;
                self.view.layoutIfNeeded();
            });
        }
        
        self.lastContentOffset = contentOffset;
    }
    //MARK: - 网络请求
    func fetchBannerAd() -> Void {
        self.bannerAd = UIView(frame: CGRectMake(0, 0, SWIFT_DEVICE_SCREEN_WIDTH, 60 + kToolbarHeight));
        
        MobiSageManager.getInstance().setPublisherID(MS_Test_PublishID, withChannel: "AppStore", auditFlag: MS_TEST_AUDIT_FLAG);
        let banner = MobiSageBanner(bannerAdSize: .Normal, delegate: nil, slotToken: MS_Test_SlotToken_Banner);
        banner.setBannerAdRefreshTime(.HalfMinute);
        banner.setBannerAdAnimeType(.Random);
        self.bannerAd.addSubview(banner);
    }
    
    func fetchArticleDetail() -> Void {
        if self.article.cacheStatus.unsignedIntValue == INSArticleCacheStatusCached.rawValue {
            self.loadWebView(self.article);
            return;
        }
        self.toolBar.p_startLoading();
        INSRequestHelper().fetchArticleDetail(self.article) { (requestHelper : INSRequestHelper!) in
            self.toolBar.p_stopLoading();
            if requestHelper.error != nil{
                NSLog("error = %@", requestHelper.error);
            }
            if requestHelper.respObject == nil{
                return;
            }
            let article_new = requestHelper.respObject as! INSArticleModel;
            self.loadWebView(article_new);
        };
    }
    func loadWebView(article:INSArticleModel) -> Void {
        if article.content.characters.count > 0{
            let htmlString = article.toHtmlString();
            self.webView.loadHTMLString(htmlString , baseURL: nil);
        }
    }
    //MARK: - 事件响应处理
    func backAction(button:UIButton) -> Void {
        self.stackController.popViewControllerAnimated(true);
    }

    func refreshAction(button:UIButton) -> Void {
        self.fetchArticleDetail();
    }
    
    func shareAction(button:UIButton) -> Void {
        let rootUrl = "http://www.wenzhaiwang.com";
        let url = rootUrl + String(article.href);
        let arv = UIActivityViewController(activityItems: [url], applicationActivities: nil);
        self.stackController.presentViewController(arv, animated: true, completion: nil);
    }
    //MARK: - 其他私有方法
    
    //MARK: - 内存管理相关
    func articleContentViewControllerDataInit(){
        
    }

}
