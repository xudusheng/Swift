//
//  XDSDigitKeyboardLayout.swift
//  XDSSwift
//
//  Created by xudosom on 16/9/25.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class XDSDigitKeyboardLayout: UICollectionViewLayout {
    
    deinit {
        NSLog("\(XDSDigitKeyboardLayout.self)===> deinit");
    }
    
    override var collectionViewContentSize: CGSize{
        return (self.collectionView?.frame.size)!;
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let full_width = UIScreen.main.bounds.width;
        let marginLeft = CGFloat(0.0);
        let horizontalGap = CGFloat(1.0);
        let marginTop = horizontalGap;
        let totalSections = (self.collectionView?.numberOfSections.cgFloatValue())!;
        let totalRows = (self.collectionView?.numberOfItems(inSection: indexPath.section).cgFloatValue())!;
        let cellHeight = ((self.collectionView?.frame.height)! - marginTop * totalSections) / totalSections;
        let cellWidth = (full_width - horizontalGap * (totalRows - 1)) /  totalRows;
        
        let origin_x = marginLeft + (cellWidth + horizontalGap) * indexPath.row.cgFloatValue();
        let origin_y = marginTop + (cellHeight + marginTop) * indexPath.section.cgFloatValue();
        
        
        let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath);
        layoutAttributes.frame = CGRect(x: origin_x, y: origin_y, width: cellWidth, height: cellHeight);
        return layoutAttributes;
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]();
        
        for section in 0 ..< (self.collectionView?.numberOfSections)!{
            let items = (self.collectionView?.numberOfItems(inSection: section))!;
            for row in 0..<items {
                let indexPath = IndexPath(item: row, section: section);
                attributes.append(self.layoutAttributesForItem(at: indexPath)!);
            }
        }
        
        return attributes;
    }
}

