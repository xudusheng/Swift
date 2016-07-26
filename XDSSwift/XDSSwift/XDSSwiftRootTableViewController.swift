//
//  XDSSwiftRootTableViewController.swift
//  XDSSwift
//
//  Created by zhengda on 16/7/26.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class XDSSwiftRootTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.swiftRootTableViewController();
        self.createSwiftRootTableViewControllerUI();
    }

    //MARK: - UI相关
    func createSwiftRootTableViewControllerUI(){
    }
    
    //MARK: - 代理方法
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
    }
    //MARK: - 网络请求
    
    //MARK: - 事件响应处理
    
    //MARK: - 其他私有方法
    
    //MARK: - 内存管理相关
    func swiftRootTableViewController(){
    }
    

    
}

