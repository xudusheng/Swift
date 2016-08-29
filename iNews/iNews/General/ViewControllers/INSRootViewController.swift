//
//  INSRootViewController.swift
//  iNews
//
//  Created by zhengda on 16/8/15.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class INSRootViewController: PRPullToRefreshViewController, UITableViewDelegate, UITableViewDataSource{

    var tableView: UITableView!;
    var page = 1;
    let fetchResults = NSMutableArray(capacity: 0);
    let INSArticleContentCellIdentifier = "INSArticleContentCell";
    override func viewDidLoad() {
        self.tableView = UITableView(frame: CGRectZero, style: .Plain);
        self.tableView.translatesAutoresizingMaskIntoConstraints = false;
        self.tableView.rowHeight = 90;
        self.tableView.registerClass(INSArticleContentCell.self, forCellReuseIdentifier: INSArticleContentCellIdentifier);
        self.view.addSubview(self.tableView);
        
        let views = ["tableView":tableView];
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: .AlignAllLeft, metrics: nil, views: views));
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: .AlignAllLeft, metrics: nil, views: views));
        
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        super.viewDidLoad();
        self.rootViewControllerDataInit();
        self.createRootViewControllerUI();
        self.refreshTriggered();
    }

    //MARK: - UI相关
    func createRootViewControllerUI(){
        self.refreshHeader.title = "美文摘抄";
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let view = UIViewController();
        view.view.backgroundColor = UIColor.yellowColor();
        self.stackController.pushViewController(view, animated: true);
    }
    //MARK: - 代理方法
    //TODO:UITableViewDelegate, UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchResults.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        let cell = tableView.dequeueReusableCellWithIdentifier(INSArticleContentCellIdentifier) as! INSArticleContentCell;
        let article = self.fetchResults[indexPath.row] as! INSArticleModel;
        cell.dataObject = article;
        cell.p_loadCell();
        return cell;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let article = self.fetchResults[indexPath.row] as! INSArticleModel;
        let contentVC = INSArticleContentViewController();
        contentVC.article = article;
        self.stackController.pushViewController(contentVC, animated: true);
    }
    //MARK: - 网络请求
    override func refreshTriggered() {
        super.refreshTriggered();
        INSRequestHelper().fetchHomePage(1, page: 1) { (requestHelper : INSRequestHelper!) in
            self.loadMoreCompletedWithNoMore(false);
            self.refreshCompleted();
            let resuls = INSDataBase.shareInstance().fetchArticlesWithLastArticle(nil, limit: 10);
            self.page = 2;
            self.fetchResults.removeAllObjects();
            self.fetchResults.addObjectsFromArray(resuls);
            self.tableView.reloadData();
        };
    }
    override func loadMoreTriggered() {
        super.loadMoreTriggered();
        INSRequestHelper().fetchHomePage(1, page: self.page) { (requestHelper : INSRequestHelper!) in
            self.loadMoreCompletedWithNoMore(false);
            self.page += 1;
            let lastArticle = self.fetchResults.lastObject as! INSArticleModel;
            let resuls = INSDataBase.shareInstance().fetchArticlesWithLastArticle(lastArticle, limit: 10)
            self.fetchResults.addObjectsFromArray(resuls);
            self.tableView.reloadData();
        };
    }
    //MARK: - 事件响应处理
    
    //MARK: - 其他私有方法
    override func scrollView() -> UIScrollView! {
        return self.tableView;
    }
    //MARK: - 内存管理相关
    func rootViewControllerDataInit(){
    }

    
}

