//
//  YSEClassifyModel.swift
//  youse
//
//  Created by zhengda on 16/9/12.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

import UIKit

class YSEClassifyModel: NSObject {
    fileprivate(set) var name:String?;
    fileprivate(set) var href:String?;
    
    override init() {
        super.init();
        self.name = "";
        self.href = "";
    }
    internal func p_setName(_ name:String?, href:String?){
        self.name = name;
        self.href = href;
    }
}
