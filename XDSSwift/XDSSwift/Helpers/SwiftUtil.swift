//
//  SwiftUtil.swift
//  XDSSwift
//
//  Created by zhengda on 16/9/6.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class SwiftUtil: NSObject {
    static internal func getViewController(storyboardName name:String,
                                                          instantiateViewControllerIdentifier identifier:String) -> UIViewController{
        let storyboard = UIStoryboard(name: name, bundle: nil);
        let instantiateViewController = storyboard.instantiateViewController(withIdentifier: identifier);
        return instantiateViewController;
    }
    
    static internal func showAlertView(presentingController:UIViewController,
                                                            title:String?,
                                                            message:String?,
                                                            buttonTitles:[String],
                                                            selected:((NSInteger)->Void)?){
//        //iOS8以上版本，使用新版UIAlertController代替UIAlertView
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert);
//        for index in 0 ..< buttonTitles.count {
//            let action = UIAlertAction(title: buttonTitles[index], style: .default, handler: { (act:UIAlertAction) in
//                if selected != nil{
//                    selected!(index);
//                }
//            })
//            alertController.addAction(action);
//        }
//        presentingController.present(alertController, animated: true, completion: nil);
    }

    static internal func showSingleAlertView(title:String?,
                                                            message:String?){
        let alertView = UIAlertView(title: title,
                                    message: message,
                                    delegate: nil,
                                    cancelButtonTitle: "确定");
        alertView.show();
    }
}
