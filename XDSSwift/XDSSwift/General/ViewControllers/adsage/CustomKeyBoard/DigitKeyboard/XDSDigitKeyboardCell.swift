//
//  XDSDigitKeyboardCell.swift
//  XDSSwift
//
//  Created by xudosom on 16/9/25.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit
public let xds_digitKeyboardCellIdentifier = "XDSDigitKeyboardCell";
class XDSDigitKeyboardCell: UICollectionViewCell {
    private let titleLabel = UILabel();
    private let subTitleLabel = UILabel();
    
    deinit {
        NSLog("\(XDSDigitKeyboardCell.self)===> deinit");
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.createEnglishKeyboardCellUI();
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createEnglishKeyboardCellUI() {
        titleLabel.font = UIFont.systemFont(ofSize: 22);
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        titleLabel.backgroundColor = UIColor.clear;
        titleLabel.textAlignment = .center;
        titleLabel.textColor = UIColor.black;
        self.contentView.addSubview(titleLabel);
        
        subTitleLabel.font = UIFont.systemFont(ofSize: 12);
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false;
        subTitleLabel.backgroundColor = UIColor.clear;
        subTitleLabel.textAlignment = .center;
        subTitleLabel.textColor = UIColor.black;
        self.contentView.addSubview(subTitleLabel);
        
        let viewDict = ["titleLabel":titleLabel, "subTitleLabel":subTitleLabel];
        let constraints_title_h = NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleLabel]|", options: .alignAllCenterX, metrics: nil, views: viewDict);
        let constraints_title_center = NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1.0, constant: 0);
        self.contentView.addConstraints(constraints_title_h + [constraints_title_center]);
        
        let constraints_subTitle_h = NSLayoutConstraint.constraints(withVisualFormat: "H:|[subTitleLabel]|", options: .alignAllCenterX, metrics: nil, views: viewDict);
        let constraints_subTitle_v = NSLayoutConstraint.constraints(withVisualFormat: "V:[titleLabel][subTitleLabel]|", options: .alignAllCenterX, metrics: nil, views: viewDict);
        self.contentView.addConstraints(constraints_subTitle_h + constraints_subTitle_v);
        
        
        //        self.contentView.layer.cornerRadius = 6;
        //        self.contentView.layer.masksToBounds = true;
        
        
        let backView = UIView(frame: self.bounds);
        backView.backgroundColor = UIColor.white;
        backView.layer.cornerRadius = 6;
        backView.layer.masksToBounds = true;
        self.backgroundView = backView;
        
        let selectedBackgroundView = UIView(frame: self.bounds);
        selectedBackgroundView.backgroundColor = UIColor.lightGray;
        selectedBackgroundView.layer.cornerRadius = 6;
        selectedBackgroundView.layer.masksToBounds = true;
        self.selectedBackgroundView = selectedBackgroundView;
    }
    
    
    public func setTitle(text:String?, subTitle:String?){
        self.titleLabel.text = text;
        self.subTitleLabel.text = subTitle;
    }
}
