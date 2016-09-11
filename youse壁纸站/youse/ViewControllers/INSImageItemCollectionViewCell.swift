//
//  INSImageItemCollectionViewCell.swift
//  youse
//
//  Created by zhengda on 16/8/29.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

import UIKit

class INSImageItemCollectionViewCell: UICollectionViewCell {

    private var bgImageView = UIImageView(frame: CGRectZero);
    private var titleLabel = UILabel(frame: CGRectZero);
    
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
    private func createImageItemCollectionViewCellUI(){
        bgImageView.backgroundColor = UIColor.lightGrayColor();
        bgImageView.translatesAutoresizingMaskIntoConstraints = false;
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        titleLabel.font = UIFont.systemFontOfSize(12);
        titleLabel.textColor = UIColor.whiteColor();
        titleLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4);
        self.contentView.addSubview(bgImageView);
        self.contentView.addSubview(titleLabel);
        
        let viewsDict = ["bgImageView":bgImageView, "titleLabel":titleLabel];
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bgImageView]|", options: .AlignAllLeft, metrics: nil, views: viewsDict));
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[bgImageView]|", options: .AlignAllLeft, metrics: nil, views: viewsDict));
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[titleLabel]|", options: .AlignAllLeft, metrics: nil, views: viewsDict));
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleLabel(25)]|", options: .AlignAllLeft, metrics: nil, views: viewsDict));
        
    }

    
    internal func p_loadCell() -> Void {
        if self.imageModel == nil {
            return;
        }
        let url = NSURL(string: imageModel!.href!);
        bgImageView.sd_setImageWithURL(url, placeholderImage: nil);
        titleLabel.text = imageModel!.title;
    }

}
