//
//  INSToolBar.swift
//  iNews
//
//  Created by zhengda on 16/8/25.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class INSToolBar: UIToolbar {
   
   internal var backButton : UIButton?;
   internal var starButton : UIButton?;
   internal var shareButton : UIButton?;
   internal var refreshButton : UIButton?;
   internal var activityIndicator : UIActivityIndicatorView?;
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.setup();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        self.setup();
    }
    
    func setup() -> Void {
        let _backButton = UIButton(frame: CGRectMake(0.0, 0.0, 60.0, 44.0));
        _backButton.setImage(UIImage(named: "navi_back_n"), forState: .Normal);
        _backButton.setImage(UIImage(named: "navi_back_p"), forState: .Highlighted);
        let backItem = UIBarButtonItem(customView: _backButton);
        self.backButton = _backButton;

        let _shareButton = UIButton(frame: CGRectMake(0.0, 0.0, 60.0, 44.0));
        _shareButton.setImage(UIImage(named: "article_share_n"), forState: .Normal);
        _shareButton.setImage(UIImage(named: "article_share_p"), forState: .Highlighted);
        let shareItem = UIBarButtonItem(customView: _shareButton);
        self.shareButton = _shareButton;

        let commentView = UIView(frame: CGRectMake(0, 0, 60, 44));
        let _activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray);
        _activityIndicator.hidesWhenStopped = true;
        _activityIndicator.center = CGPointMake(CGRectGetWidth(commentView.frame)/2, CGRectGetHeight(commentView.frame)/2);
        commentView.addSubview(_activityIndicator);
        self.activityIndicator = _activityIndicator;
        
        let _refreshButton = UIButton(frame: CGRectMake(0.0, 0.0, 60.0, 44.0));
        _refreshButton.setImage(UIImage(named: "article_comment_n"), forState: .Normal);
        _refreshButton.setImage(UIImage(named: "article_comment_p"), forState: .Highlighted);
        let refreshItem = UIBarButtonItem(customView: _refreshButton);
        self.refreshButton = _refreshButton;
        let fixtdItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil);
        fixtdItem.width = -16;
        let flexibleItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil);

        self.items = [fixtdItem, backItem, flexibleItem, shareItem, flexibleItem, refreshItem, fixtdItem];
    }
    
    internal func p_startLoading(){
        self.refreshButton?.hidden = true;
        self.activityIndicator?.startAnimating();
    }

    internal func p_stopLoading(){
        self.refreshButton?.hidden = false;
        self.activityIndicator?.stopAnimating();
    }
}
