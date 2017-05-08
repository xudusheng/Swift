//
//  INSImageItemCollectionViewCell.swift
//  youse
//
//  Created by zhengda on 16/8/29.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

import UIKit

class INSImageItemCollectionViewCell: UICollectionViewCell {

    fileprivate var bgImageView = UIImageView(frame: CGRect.zero);
    fileprivate var titleLabel = UILabel(frame: CGRect.zero);
    
    var imageModel : YSEImageModel?;
    //MARK:init
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.createImageItemCollectionViewCellUI();
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:UI
    fileprivate func createImageItemCollectionViewCellUI(){
        bgImageView.backgroundColor = UIColor.lightGray;
        bgImageView.translatesAutoresizingMaskIntoConstraints = false;
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        titleLabel.font = UIFont.systemFont(ofSize: 12);
        titleLabel.textColor = UIColor.white;
        titleLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4);
        self.contentView.addSubview(bgImageView);
        self.contentView.addSubview(titleLabel);
        
        let viewsDict = ["bgImageView":bgImageView, "titleLabel":titleLabel];
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[bgImageView]|", options: .alignAllLeft, metrics: nil, views: viewsDict));
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[bgImageView]|", options: .alignAllLeft, metrics: nil, views: viewsDict));
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleLabel]|", options: .alignAllLeft, metrics: nil, views: viewsDict));
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[titleLabel(25)]|", options: .alignAllLeft, metrics: nil, views: viewsDict));
        
    }

    
    internal func p_loadCell() -> Void {
        if self.imageModel == nil {
            return;
        }
        let url = URL(string: imageModel!.href!);
        bgImageView.sd_setImage(with: url, placeholderImage: nil);
        titleLabel.text = imageModel!.title;
    }

}
