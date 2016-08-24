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
    
    internal var article : INSArticleModel!;
    var webView : UIWebView!;
    var statusBarHeight : NSLayoutConstraint!;
    var lastContentOffset : CGPoint = CGPointMake(0, 0);

    var bannerAd : MobiSageBanner?;
    
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
        let viewDict = ["webView":webView];
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: .AlignAllLeft, metrics: nil, views: viewDict));
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[webView]|", options: .AlignAllLeft, metrics: nil, views: viewDict));
        
        let statusBarBackView = UIView(frame: CGRectZero);
        statusBarBackView.backgroundColor = UIColor.yellowColor();
        statusBarBackView.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(statusBarBackView);
        let statusBarBackViewDict = ["statusBarBackView":statusBarBackView];
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[statusBarBackView]|", options: .AlignAllLeft, metrics: nil, views: statusBarBackViewDict));
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[statusBarBackView]", options: .AlignAllLeft, metrics: nil, views: statusBarBackViewDict));
        
        self.statusBarHeight = NSLayoutConstraint(item: statusBarBackView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: kStatusBarHeight);
        self.view.addConstraint(self.statusBarHeight);
        var insets = self.webView.scrollView.contentInset;
        insets.top = kStatusBarHeight;
        self.webView.scrollView.contentInset = insets;

        
        let requestHelper = INSRequestHelper();
        requestHelper.fetchArticleDetail(self.article) { (responseObject:AnyObject!, error:NSError!) in
            if error != nil{
                NSLog("error = %@", error);
            }
            if responseObject == nil{
                return;
            }
            let contentString = responseObject as! String;
            if contentString.characters.count > 0{
                self.article.content = contentString;
                let htmlString = self.article.toHtmlString();
                self.webView.loadHTMLString(htmlString , baseURL: nil);
            }
        };
    }
    
    //MARK: - 代理方法
    //UIWebViewDelegate
    func webViewDidFinishLoad(webView: UIWebView) {
//        NSLog("contentSize = \(webView.scrollView.contentSize)");
//        var contentSize = webView.scrollView.contentSize;
//        let button = UIButton(type: .Custom);
//        button.frame = CGRectMake(0, webView.scrollView.contentSize.height, SWIFT_DEVICE_SCREEN_WIDTH, 44);
//        button.backgroundColor = UIColor.redColor();
//        button.addTarget(self, action: #selector(INSArticleContentViewController.buttonClick(_:)), forControlEvents:UIControlEvents.TouchUpInside);
//        webView.scrollView.addSubview(button);
//        contentSize.height += CGRectGetHeight(button.frame);
//        webView.scrollView.contentSize = contentSize;
        
        if (self.bannerAd != nil) {
            var contentSize = webView.scrollView.contentSize;
            var frame = self.bannerAd?.frame;
            frame?.origin.y = contentSize.height;
            self.bannerAd?.frame = frame!;
            webView.scrollView.addSubview(self.bannerAd!);
            contentSize.height += CGRectGetHeight(self.bannerAd!.frame);
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
            UIView.animateWithDuration(0.3, animations: {
                var insets = scrollView.scrollIndicatorInsets;
                insets.top = 0;
                scrollView.scrollIndicatorInsets = insets;
                self.view.layoutIfNeeded();
            });
        }
        else {
            // pull down              
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide);
            self.statusBarHeight.constant = self.kStatusBarHeight;
            UIView.animateWithDuration(0.3, animations: {
                var insets = scrollView.scrollIndicatorInsets;
                insets.top = self.kStatusBarHeight;
                scrollView.scrollIndicatorInsets = insets;
                self.view.layoutIfNeeded();
            });
        }
        
        self.lastContentOffset = contentOffset;
    }
    //MARK: - 网络请求
    //MARK: - 网络请求
    func fetchBannerAd() -> Void {
        MobiSageManager.getInstance().setPublisherID(MS_Test_PublishID, withChannel: "AppStore", auditFlag: MS_TEST_AUDIT_FLAG);
        self.bannerAd = MobiSageBanner(bannerAdSize: .Normal, delegate: nil, slotToken: MS_Test_SlotToken_Banner);
        bannerAd!.setBannerAdRefreshTime(.HalfMinute);
        bannerAd!.setBannerAdAnimeType(.Random);
    }
    //MARK: - 事件响应处理
    
    //MARK: - 其他私有方法
    
    //MARK: - 内存管理相关
    func articleContentViewControllerDataInit(){
        
    }

}
