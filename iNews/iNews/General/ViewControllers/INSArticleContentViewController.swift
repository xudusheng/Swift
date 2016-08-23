//
//  INSArticleContentViewController.swift
//  iNews
//
//  Created by zhengda on 16/8/23.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class INSArticleContentViewController: UIViewController {
    internal var article : INSArticleModel!;
    var webView : UIWebView!;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.articleContentViewControllerDataInit();
        self.createArticleContentViewControllerUI();
    }

    
    //MARK: - UI相关
    func createArticleContentViewControllerUI(){
        self.webView = UIWebView(frame: self.view.bounds);
        self.view.addSubview(self.webView);
        
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
    
    //MARK: - 网络请求
    
    //MARK: - 事件响应处理
    
    //MARK: - 其他私有方法
    
    //MARK: - 内存管理相关
    func articleContentViewControllerDataInit(){
        
    }

}
