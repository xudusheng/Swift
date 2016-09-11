//
//  YSEColorModel.swift
//  youse
//
//  Created by xudosom on 16/9/11.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

import UIKit

class YSEColorModel: NSObject {
    private(set) var colorName:String?;
    private(set) var href:String?;
    
    override init() {
        super.init();
        self.colorName = "";
        self.href = "";
    }
    internal func p_setColorName(name:String?, href:String?){
        self.colorName = name;
        self.href = href;
    }
}
