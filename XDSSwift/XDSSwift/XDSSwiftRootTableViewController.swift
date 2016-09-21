//
//  XDSSwiftRootTableViewController.swift
//  XDSSwift
//
//  Created by zhengda on 16/7/26.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit


enum CellIndexPath:Int {
    case coreAnimation
    case wifi
    case runtime
    
    case layerSprite
    case keyboard
}

class XDSSwiftRootTableViewController: UITableViewController {
    let IndexPath_ : [String:CellIndexPath] = [
        "0,0" : .coreAnimation,
        "0,1" : .wifi,
        "0,2" : .runtime,
        
        "1,0" : .layerSprite,
        "1,1" : .keyboard,
    ];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.swiftRootTableViewController();
        self.createSwiftRootTableViewControllerUI();
    }


    //MARK: - UI相关
    func createSwiftRootTableViewControllerUI(){
        self.hidesTopBarWhenPushed = true;
    }
    
    //MARK: - 代理方法
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        var vc : UIViewController?;
        let indexPathKey = "\(indexPath.section),\(indexPath.row)";
        let index = IndexPath_[indexPathKey]! as CellIndexPath;
        switch index {
        case .coreAnimation:
            vc = SwiftUtil.getViewController(storyboardName: "Main",
                                             instantiateViewControllerIdentifier: "XDSCoreAnimationTableViewController");
            break;
        case .wifi:
            vc = SwiftUtil.getViewController(storyboardName: "Main",
                                             instantiateViewControllerIdentifier: "XDSWIFIFileTransferViewController");
            break;
        case .runtime:
            let runtimeVC = OCRuntimeViewController();
            vc = runtimeVC;
            break;
            
        case .layerSprite:
            vc = XDSLayerSpritesViewController();
            break;
        case .keyboard:
            vc = XDSCustomKeyBoardViewController();
            break;
        }
        
        if vc != nil {
            vc?.view.backgroundColor = UIColor.white;
            vc?.hidesBottomBarWhenPushed = true;
            self.navigationController?.pushViewController(vc!, animated: true);
        }

    }

    //MARK: - 网络请求
    
    //MARK: - 事件响应处理
    
    //MARK: - 其他私有方法
    
    //MARK: - 内存管理相关
    func swiftRootTableViewController(){
    }
    

    
}

