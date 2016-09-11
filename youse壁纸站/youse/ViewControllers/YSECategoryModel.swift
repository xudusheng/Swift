//
//  YSECategoryModel.swift
//  youse
//
//  Created by xudosom on 16/9/11.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

import UIKit

class YSECategoryModel: NSObject {
    private(set) var title:String?;
    private(set) var href:String?;
    
    override init() {
        super.init();
        self.title = "";
        self.href = "";
    }
    internal func p_setTitle(title:String?, href:String?){
        self.title = title;
        self.href = href;
    }
}
