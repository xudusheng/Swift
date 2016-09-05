//
//  XDSAnyObject.swift
//  XDSSwift
//
//  Created by zhengda on 16/9/2.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import Foundation
class XDSAnyObject{
    
    static internal func toString(from from:AnyObject?) -> String{
        return "\(from)";
    }
    
}

internal func FromAnyObjectToString(from from:AnyObject?) -> String{
    if from is String {
        return from as! String;
    }
    return "\(from)";
}