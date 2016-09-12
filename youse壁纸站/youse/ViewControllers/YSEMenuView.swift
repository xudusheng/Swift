//
//  YSEMenuView.swift
//  youse
//
//  Created by zhengda on 16/8/30.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

import UIKit

class YSEMenuView: UIView, UITableViewDelegate, UITableViewDataSource{
    
    var menuTableView : UITableView!;
    var categoryList : [YSEClassifyModel]!{
        didSet{
            self.menuTableView.reloadData();
        }
    }
    var callBack : (YSEClassifyModel  -> Void)?;
    
    var heightConstraint : NSLayoutConstraint!;
    let cellHeight = CGFloat(44.0);
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        categoryList = [YSEClassifyModel]();
        self.createMenuUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createMenuUI() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.2);
        self.menuTableView = UITableView(frame: CGRectZero, style: .Grouped);
        menuTableView.backgroundColor = UIColor.whiteColor();
        menuTableView.translatesAutoresizingMaskIntoConstraints = false;
        menuTableView.delegate = self;
        menuTableView.dataSource = self;
        self.addSubview(menuTableView);
        
        let viewsDict = ["menuTableView":menuTableView];
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[menuTableView]|", options: .AlignAllLeft, metrics: nil, views: viewsDict));
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-64-[menuTableView]", options: .AlignAllLeft, metrics: nil, views: viewsDict));
        self.heightConstraint = NSLayoutConstraint(item: menuTableView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: CGFloat.min);
        self.addConstraint(heightConstraint);
    }
    
    internal func p_show(backView_finalFrame finalFrame:CGRect) {
        self.frame = finalFrame;
        UIView.animateWithDuration(0.3, animations: {
            self.heightConstraint.constant = self.cellHeight * CGFloat(self.categoryList.count);
            self.layoutIfNeeded();
        }) { (finished:Bool) in
        }
    }

    internal func p_hide(backView_finalFrame finalFrame:CGRect) {
        
        UIView.animateWithDuration(0.3, animations: { 
            self.heightConstraint.constant = CGFloat.min;
            self.layoutIfNeeded();
        }) { (finished:Bool) in
            self.frame = finalFrame;
        }
    }
    
    //MARK:delegate
    //TODO:UITableViewDelegate, UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "cell";
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier);
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: identifier);
        }
        let category = categoryList[indexPath.row];
        cell?.textLabel?.text = category.name;
        return cell!;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.min;
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min;
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let category = categoryList[indexPath.row];
        callBack?(category);
    }

}
