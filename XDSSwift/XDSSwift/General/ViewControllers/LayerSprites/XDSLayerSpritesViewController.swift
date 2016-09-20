//
//  XDSLayerSpritesViewController.swift
//  XDSSwift
//
//  Created by zhengda on 16/7/27.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class XDSLayerSpritesViewController: XDSRootViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.layerSpritesViewControllerDataInit();
        self.createLayerSpritesViewControllerUI();
    }

    //MARK: - UI相关
    func createLayerSpritesViewControllerUI(){
        self.title = "瓦片地图";

        let plistPath = Bundle.main.path(forResource: "lostgarden", ofType: "plist");
        let imageMap = LSImageMap(contentsOfFile: plistPath)!;
        let height:CGFloat = 80.0;
        let width:CGFloat = 80.0;
        let gap:CGFloat = 10.0;
        for index in 0 ..< imageMap.imageCount() {
            print("imageName = \(imageMap.imageName(at: index))");
            let image = imageMap.image(at: index);
            let originX = 30.0 + (width + gap) * (CGFloat(index%3));
            let originY = 80 + (height + gap) * (CGFloat(index/3));
            
            let layerView = UIView(frame: CGRect(x:originX, y:originY, width:width, height:height));
            layerView.layer.contents = image?.cgImage;
            layerView.layer.contentsScale = (image?.scale)!;
            layerView.layer.contentsRect = (image?.contentsRect)!;
            layerView.transform = (image?.transform)!;
            self.view.addSubview(layerView);
        }
    }
    
    //MARK: - 代理方法
    
    //MARK: - 网络请求
    
    //MARK: - 事件响应处理
    
    //MARK: - 其他私有方法
    
    //MARK: - 内存管理相关
    func layerSpritesViewControllerDataInit(){
    }

}
