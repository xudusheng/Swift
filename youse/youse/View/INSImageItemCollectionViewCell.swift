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
    
    var imageModel : YSEImageGroupModel?{
        didSet{
            self.downloadImagePageInfo();
        }
    };
    
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
        bgImageView.translatesAutoresizingMaskIntoConstraints = false;
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        titleLabel.backgroundColor = UIColor.yellowColor();
        self.contentView.addSubview(bgImageView);
        self.contentView.addSubview(titleLabel);
        
        let viewsDict = ["bgImageView":bgImageView, "titleLabel":titleLabel];
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bgImageView]|", options: .AlignAllLeft, metrics: nil, views: viewsDict));
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[bgImageView]|", options: .AlignAllLeft, metrics: nil, views: viewsDict));
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[titleLabel]|", options: .AlignAllLeft, metrics: nil, views: viewsDict));
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[titleLabel(30)]|", options: .AlignAllLeft, metrics: nil, views: viewsDict));
    }
    
    
    
    //MARK:download
    func downloadImagePageInfo(){
        if imageModel == nil {
            return;
        }
        
        if imageModel?.has_get_total_page == YSEBOOLString.FALSE {
            self.fetchFirstImagePage();
        }else{
            if imageModel?.is_ready_toshow == YSEBOOLString.FALSE {
                //请求最后一页
                self.fetchLaseImagePage();
            }
        }
    }
    
    private func fetchFirstImagePage(){
        YSERequestFetcher().p_fetchFirstImagePage(imageModel!) { (requestFetcher) in
            if requestFetcher.responseObj != nil{
                self.imageModel = requestFetcher.responseObj as? YSEImageGroupModel;
                if self.imageModel?.has_get_total_page == YSEBOOLString.TRUE{
                    self.fetchLaseImagePage();
                }
            }
        };
    }
    
    private func fetchLaseImagePage(){
        YSERequestFetcher().p_fetchLastImagePage(imageModel!) { (requestFetcher) in
            if requestFetcher.responseObj != nil{
                self.imageModel = requestFetcher.responseObj as? YSEImageGroupModel;
            }
        };
    }
    
    
    internal func p_loadCell() -> Void {
        if self.imageModel == nil {
            return;
        }
        let url = NSURL(string: imageModel!.item_img_url)
        bgImageView.sd_setImageWithURL(url, placeholderImage: nil);
        titleLabel.text = imageModel!.title;
    }

}
