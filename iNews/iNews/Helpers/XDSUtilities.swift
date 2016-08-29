//
//  XDSUtilities.swift
//  iNews
//
//  Created by zhengda on 16/8/16.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class XDSUtilities: NSObject {

    static internal func getViewController(storyboardName:String, instantiateViewControllerIdentifier:String) -> UIViewController{
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil);
        let instantiateViewController = storyboard.instantiateViewControllerWithIdentifier(instantiateViewControllerIdentifier);
        return instantiateViewController;
    }

    static internal func labelWithFrame(frame frame:CGRect,
                                              textAlignment:NSTextAlignment,
                                              font:UIFont,
                                              text:String,
                                              textColor:UIColor) -> UILabel{
        let label = UILabel(frame: frame);
        label.text = text;
        label.textAlignment = textAlignment;
        label.font = font;
        label.textColor = textColor;
        return label;
    }

}
