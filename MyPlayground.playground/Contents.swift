//: Playground - noun: a place where people can play

import UIKit

protocol StringProtocol {
    func isFloatValue() -> Void;
}
extension String : StringProtocol{
    public func md5String() -> String{
        return self;
    }
    
    func isFloatValue() {
        return;
    }
}