//
//  String_Extension_XDS.swift
//  XDSSwift
//
//  Created by zhengda on 16/9/2.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

//public protocol XDSAnyObject : AnyObject{
//    func toString() -> String;
//}

extension String{
    func length() -> Int {
        return self.characters.count;
    }
    
    public func toString() -> String {
        return "\(self)";
    }
}

