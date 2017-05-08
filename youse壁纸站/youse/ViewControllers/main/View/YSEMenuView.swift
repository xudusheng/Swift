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
    var callBack : ((YSEClassifyModel)  -> Void)?;
    
    var heightConstraint : NSLayoutConstraint!;
    let cellHeight = CGFloat(44.0);
    let topHeight = 64;
    override init(frame: CGRect) {
        super.init(frame: frame);
        categoryList = [YSEClassifyModel]();
        self.createMenuUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func createMenuUI() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.2);
        self.menuTableView = UITableView(frame: CGRect.zero, style: .grouped);
        menuTableView.backgroundColor = UIColor.white;
        menuTableView.translatesAutoresizingMaskIntoConstraints = false;
        menuTableView.delegate = self;
        menuTableView.dataSource = self;
        self.addSubview(menuTableView);
        
        let viewsDict = ["menuTableView":menuTableView];
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[menuTableView]|", options: .alignAllLeft, metrics: nil, views: viewsDict));
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-top-[menuTableView]", options: .alignAllLeft, metrics: ["top":topHeight], views: viewsDict));
        self.heightConstraint = NSLayoutConstraint(item: menuTableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: CGFloat.leastNormalMagnitude);
        self.addConstraint(heightConstraint);
    }
    
    internal func p_show(backView_finalFrame finalFrame:CGRect) {
        self.frame = finalFrame;
        var height = self.cellHeight * CGFloat(self.categoryList.count);
        if height > SWIFT_DEVICE_SCREEN_HEIGHT/2 {
            height = SWIFT_DEVICE_SCREEN_HEIGHT/2
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.heightConstraint.constant = height;
            self.layoutIfNeeded();
        }, completion: { (finished:Bool) in
        }) 
    }

    internal func p_hide(backView_finalFrame finalFrame:CGRect) {
        
        UIView.animate(withDuration: 0.3, animations: { 
            self.heightConstraint.constant = CGFloat.leastNormalMagnitude;
            self.layoutIfNeeded();
        }, completion: { (finished:Bool) in
            self.frame = finalFrame;
        }) 
    }
    
    //MARK:delegate
    //TODO:UITableViewDelegate, UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell";
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier);
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier);
        }
        let category = categoryList[indexPath.row];
        cell?.textLabel?.text = category.name;
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude;
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categoryList[indexPath.row];
        callBack?(category);
    }

}
