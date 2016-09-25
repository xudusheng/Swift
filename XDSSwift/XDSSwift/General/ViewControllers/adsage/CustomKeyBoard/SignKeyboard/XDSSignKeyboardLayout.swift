//
//  XDSSignKeyboardLayout.swift
//  XDSSwift
//
//  Created by xudosom on 16/9/25.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class XDSSignKeyboardLayout: UICollectionViewLayout {
    deinit {
        NSLog("\(XDSEnglishKeyboardLayout.self)===> deinit");
    }
    
    override var collectionViewContentSize: CGSize{
        return (self.collectionView?.frame.size)!;
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let full_width = UIScreen.main.bounds.width;
        let marginLeft = CGFloat(3.0);
        let horizontalGap = 2*marginLeft;
        let marginTop = CGFloat(12);
        let totalSections = (self.collectionView?.numberOfSections.cgFloatValue())!;
        let totalRows = (self.collectionView?.numberOfItems(inSection: indexPath.section).cgFloatValue())!;
        let cellHeight = ((self.collectionView?.frame.height)! - marginTop * totalSections) / totalSections;
        var cellWidth = (full_width - horizontalGap * 10) / 10;
        
        let leftBlankWidth = (full_width - (cellWidth + horizontalGap) * totalRows)/2;
        var origin_x = leftBlankWidth + marginLeft + (cellWidth + horizontalGap) * indexPath.row.cgFloatValue();
        let origin_y = marginTop*3/4 + (cellHeight + marginTop) * indexPath.section.cgFloatValue();
        
        let title = xds_sign_keyboard_letters[indexPath.section][indexPath.row];
        
        if title == xds_title_shift {//shift键
            origin_x = marginLeft;
            cellWidth += leftBlankWidth;
        }else if title == xds_title_delete{//delete键
            cellWidth += leftBlankWidth;
            origin_x = full_width - cellWidth - marginLeft;
        }else if title == xds_title_digit_switch {//数字切换键
            origin_x = marginLeft;
            cellWidth = (full_width - (cellWidth + horizontalGap)*(totalRows - 2))/2 - horizontalGap;
        } else if title == xds_title_english_switch {//英文切换键
            cellWidth = (full_width - (cellWidth + horizontalGap)*(totalRows - 2))/2 - horizontalGap;
            origin_x = full_width - cellWidth - marginLeft;
        }
        
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
