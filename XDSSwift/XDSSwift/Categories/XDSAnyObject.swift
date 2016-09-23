//
//  XDSAnyObject.swift
//  XDSSwift
//
//  Created by zhengda on 16/9/2.
//  Copyright © 2016年 zhengda. All rights reserved.
//
import UIKit
import Foundation
//class XDSAnyObject{
//    
//    static internal func toString(from:AnyObject?) -> String{
//        return "\(from)";
//    }
//    
//}
//
//internal func FromAnyObjectToString(from:AnyObject?) -> String{
//    if from is String {
//        return from as! String;
//    }
//    return "\(from)";
//}

public protocol Then{}
extension Then where Self: AnyObject {
    public func then ( block: (Self) -> Void) -> Self{
        block(self);
        return self;
    }
}

extension NSObject: Then{}
