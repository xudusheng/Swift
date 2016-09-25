//
//  XDSEnglishKeyboardCell.swift
//  XDSSwift
//
//  Created by xudosom on 16/9/24.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit
import ObjectiveC

public let xds_englishKeyboardCellIdentifier = "EnglishKeyboardCell";

class XDSEnglishKeyboardCell: UICollectionViewCell {

    private let titleLabel = UILabel();
    var cellKey : String?;
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.createEnglishKeyboardCellUI();
    }
    
    deinit {
        NSLog("\(XDSEnglishKeyboardCell.self)===> deinit");
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createEnglishKeyboardCellUI() {
        titleLabel.font = UIFont.systemFont(ofSize: 20);
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        titleLabel.backgroundColor = UIColor.clear;
        titleLabel.textAlignment = .center;
        titleLabel.textColor = UIColor.black;
        self.contentView.addSubview(titleLabel);
        
        let viewDict = ["titleLabel":titleLabel];
        let constraints_h = NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleLabel]|", options: .alignAllCenterX, metrics: nil, views: viewDict);
        let constraints_v = NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleLabel]|", options: .alignAllCenterY, metrics: nil, views: viewDict);
        self.contentView.addConstraints(constraints_h+constraints_v);
        
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
    
    
    public func setTitle(text:String?){
        self.titleLabel.text = text;
        self.cellKey = text;
    }
}

