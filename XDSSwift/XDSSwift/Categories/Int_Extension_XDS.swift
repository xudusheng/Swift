//
//  Int_Extension_XDS.swift
//  XDSSwift
//
//  Created by zhengda on 16/9/22.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

extension Int{
    func cgFloatValue() -> CGFloat {
        return CGFloat(self);
    }
    
    func integerValue() -> NSInteger {
        return NSInteger(self);
    }
}

extension Float{
    func cgFloatValue() -> CGFloat {
        return CGFloat(self);
    }
}


extension Double {
    func cgFloatValue() -> CGFloat {
        return CGFloat(self);
    }
}
