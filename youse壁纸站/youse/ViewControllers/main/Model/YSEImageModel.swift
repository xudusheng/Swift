//
//  YSEImageModel.swift
//  youse
//
//  Created by xudosom on 16/9/11.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

import UIKit

class YSEImageModel: NSObject {
    fileprivate(set) var title:String?;
    fileprivate(set) var href:String?;
    fileprivate(set) var width:String?;
    fileprivate(set) var height:String?;
    
    override init() {
        super.init();
        self.title = "";
        self.href = "";
        self.width = String(CGFloat.leastNormalMagnitude);
        self.height = String(CGFloat.leastNormalMagnitude);
    }
    
    internal func p_setTitle(_ title:String?, href:String?, width:String?, height:String?){
        self.title = title;
        self.href = href;
        self.width = width;
        self.height = height;
    }
}
