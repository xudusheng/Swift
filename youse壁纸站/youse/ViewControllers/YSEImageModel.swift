//
//  YSEImageModel.swift
//  youse
//
//  Created by xudosom on 16/9/11.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

import UIKit

class YSEImageModel: NSObject {
    private(set) var title:String?;
    private(set) var href:String?;
    private(set) var width:String?;
    private(set) var height:String?;
    
    override init() {
        super.init();
        self.title = "";
        self.href = "";
        self.width = String(CGFloat.min);
        self.height = String(CGFloat.min);
    }
    
    internal func p_setTitle(title:String?, href:String?, width:String?, height:String?){
        self.title = title;
        self.href = href;
        self.width = width;
        self.height = height;
    }
}
