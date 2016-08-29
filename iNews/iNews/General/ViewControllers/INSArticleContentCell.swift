//
//  INSArticleContentCell.swift
//  iNews
//
//  Created by zhengda on 16/8/26.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class INSArticleContentCell: INSRootTableViewCell {
    
    var titleLabel:UILabel!;
    var summaryLabel:UILabel!;
    var pubDateLabel:UILabel!;
    var sessionDataTask : NSURLSessionDataTask!;

    
    override var dataObject: AnyObject?{
        set{
            super.dataObject = newValue;
            if (super.dataObject?.isKindOfClass(INSArticleModel.self) == true) {
                self.downloadArticle(newValue as! INSArticleModel);        
            }
        }
        get{
            return super.dataObject;
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.createArticleContentCell();
    }
    
    func createArticleContentCell() -> Void {
        self.titleLabel = XDSUtilities.labelWithFrame(frame: CGRectZero,
                                                      textAlignment: .Left,
                                                      font: UIFont.systemFontOfSize(15),
                                                      text: "xxxxx",
                                                      textColor: UIColor.blackColor());
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.contentView.addSubview(self.titleLabel);
        
        self.summaryLabel = XDSUtilities.labelWithFrame(frame: CGRectZero,
                                                      textAlignment: .Left,
                                                      font: UIFont.systemFontOfSize(13),
                                                      text: "yyyyyy",
                                                      textColor: UIColor.darkGrayColor());
        self.summaryLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.summaryLabel.numberOfLines = 2;
        self.contentView.addSubview(self.summaryLabel);

        self.pubDateLabel = XDSUtilities.labelWithFrame(frame: CGRectZero,
                                                        textAlignment: .Left,
                                                        font: UIFont.systemFontOfSize(12),
                                                        text: "发表于：",
                                                        textColor: UIColor.lightGrayColor());
        self.pubDateLabel.translatesAutoresizingMaskIntoConstraints = false;
        self.contentView.addSubview(self.pubDateLabel);
        
        let viewsDict = ["titleLabel":titleLabel, "summaryLabel":summaryLabel, "pubDateLabel":pubDateLabel];
        let constraint_title_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[titleLabel]-15-|", options: .AlignAllLeft, metrics: nil, views: viewsDict);
        let constraint_summary_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[summaryLabel]-15-|", options: .AlignAllLeft, metrics: nil, views: viewsDict);
        let constraint_pubDate_H = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[pubDateLabel]-15-|", options: .AlignAllLeft, metrics: nil, views: viewsDict);
        let constraint_V = NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[titleLabel]-5-[summaryLabel]-5-[pubDateLabel]-5-|", options: .AlignAllLeft, metrics: nil, views: viewsDict);
        self.contentView.addConstraints(constraint_title_H);
        self.contentView.addConstraints(constraint_summary_H);
        self.contentView.addConstraints(constraint_pubDate_H);
        self.contentView.addConstraints(constraint_V);
    }
    
    func downloadArticle(article : INSArticleModel) -> Void {
        let cacheStatus = article.cacheStatus.unsignedIntValue;
        if (cacheStatus != INSArticleCacheStatusNone.rawValue) {
            return;
        }
        if self.sessionDataTask != nil {
            self.sessionDataTask.cancel();
            self.sessionDataTask = nil;
        }
        
        self.sessionDataTask = INSRequestHelper().fetchArticleDetail(article, complete: { (requestHelper : INSRequestHelper!) in
            if requestHelper.error == nil{
//                let article_new = requestHelper.respObject as! INSArticleModel;
//                NSLog("article_new = %@", article_new);
            }
        });
        
    }
    
    override func p_loadCell() {
        let article = self.dataObject as? INSArticleModel;
        self.titleLabel.text = article?.title;
        self.summaryLabel.text = article?.summary;
    }
    
}
