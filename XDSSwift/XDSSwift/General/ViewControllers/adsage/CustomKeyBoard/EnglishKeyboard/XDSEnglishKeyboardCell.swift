//
//  XDSEnglishKeyboardCell.swift
//  XDSSwift
//
//  Created by xudosom on 16/9/24.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit
public let xds_englishKeyboardCellIdentifier = "EnglishKeyboardCell";

class XDSEnglishKeyboardCell: UICollectionViewCell {

    private let titleLabel = UILabel();
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.createEnglishKeyboardCellUI();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createEnglishKeyboardCellUI() {
        titleLabel.font = UIFont.systemFont(ofSize: 20);
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        titleLabel.backgroundColor = UIColor.white;
        titleLabel.textAlignment = .center;
        titleLabel.textColor = UIColor.blue;
        self.contentView.addSubview(titleLabel);
        
        let viewDict = ["titleLabel":titleLabel];
        let constraints_h = NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleLabel]|", options: .alignAllCenterX, metrics: nil, views: viewDict);
        let constraints_v = NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleLabel]|", options: .alignAllCenterY, metrics: nil, views: viewDict);
        self.contentView.addConstraints(constraints_h+constraints_v);
        
        self.contentView.layer.cornerRadius = 6;
        self.contentView.layer.masksToBounds = true;
    }
    
    
    public func setTitle(text:String?){
        self.titleLabel.text = text;
    }
}
