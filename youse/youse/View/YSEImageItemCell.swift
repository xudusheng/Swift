//
//  YSEImageItemCell.swift
//  youse
//
//  Created by xudosom on 16/8/27.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

import UIKit

class YSEImageItemCell: YSERootTableViewCell {

    
    override func p_loadCell(){
        let imageGroupModel = self.contentData as? YSEImageGroupModel;
        if imageGroupModel == nil {
            return;
        }
        
        if imageGroupModel?.has_get_total_page == YSEBOOLString.FALSE {
            self.fetchFirstImagePage();
        }else{
            if imageGroupModel?.is_ready_toshow == YSEBOOLString.FALSE {
                //请求最后一页
                self.fetchLaseImagePage();
            }else{
                self.configUI();
            }
        }
        
    }
    
    private func fetchFirstImagePage(){
        let imageGroupModel = self.contentData as? YSEImageGroupModel;
        YSERequestFetcher().p_fetchFirstImagePage(imageGroupModel!) { (requestFetcher) in
            if requestFetcher.responseObj != nil{
                self.contentData = requestFetcher.responseObj;
                let newModel = self.contentData as! YSEImageGroupModel;
                if newModel.has_get_total_page == YSEBOOLString.TRUE{
                    self.fetchLaseImagePage();
                }
            }
        };
    }
    
    private func fetchLaseImagePage(){
        let imageGroupModel = self.contentData as? YSEImageGroupModel;
        YSERequestFetcher().p_fetchLastImagePage(imageGroupModel!) { (requestFetcher) in
            if requestFetcher.responseObj != nil{
                self.contentData = requestFetcher.responseObj;
                self.configUI();
            }
            
        };
    }

    private func configUI(){
        if self.contentData == nil {
            return;
        }
        let imageGroupModel = self.contentData as! YSEImageGroupModel;
        NSLog("xxxxxxxxxxxxx");
        let url = NSURL(string: imageGroupModel.item_img_url)
        self.imageView?.sd_setImageWithURL(url, placeholderImage: nil);
        self.textLabel?.text = imageGroupModel.title;
    }
}
