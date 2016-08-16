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
    
    override func viewDidLoad() {
        self.tableView = UITableView(frame: CGRectZero, style: .Grouped);
        self.tableView.translatesAutoresizingMaskIntoConstraints = false;
        self.view.addSubview(self.tableView);
//        let top = NSLayoutConstraint(item: self.tableView,
//                                     attribute: .Top,
//                                     relatedBy: .Equal,
//                                     toItem: self.view,
//                                     attribute: .Top,
//                                     multiplier: 1.0,
//                                     constant: 0.0);
//        let bottom = NSLayoutConstraint(item: self.tableView,
//                                        attribute: .Bottom,
//                                        relatedBy: .Equal,
//                                        toItem: self.view,
//                                        attribute: .Bottom,
//                                        multiplier: 1.0,
//                                        constant: 0.0);
//        let left = NSLayoutConstraint(item: self.tableView,
//                                      attribute: .Left,
//                                      relatedBy: .Equal,
//                                      toItem: self.view,
//                                      attribute: .Left,
//                                      multiplier: 1.0,
//                                      constant: 0.0);
//        let right = NSLayoutConstraint(item: self.tableView,
//                                       attribute: .Right,
//                                       relatedBy: .Equal,
//                                       toItem: self.view,
//                                       attribute: .Right,
//                                       multiplier: 1.0,
//                                       constant: 0.0);
//        self.view.addConstraint(top);
//        self.view.addConstraint(bottom);
//        self.view.addConstraint(left);
//        self.view.addConstraint(right);
        let views = ["tableView":tableView];
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: .AlignAllLeft, metrics: nil, views: views));
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: .AlignAllLeft, metrics: nil, views: views));
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        super.viewDidLoad();
        NSLog("controllers = %@", self.childViewControllers);
        INSRequestHelper.fetchHomePage(1, page: 1);
        self.rootViewControllerDataInit();
        self.createRootViewControllerUI();
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
        return 10;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "xxxxx";
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier);
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: identifier);
        }
        cell?.textLabel?.text = identifier;
        return cell!;
    }
    
    //MARK: - 网络请求
    
    //MARK: - 事件响应处理
    
    //MARK: - 其他私有方法
    override func scrollView() -> UIScrollView! {
        return self.tableView;
    }
    //MARK: - 内存管理相关
    func rootViewControllerDataInit(){
    }

    
}

