//
//  YSEMainViewController.swift
//  youse
//
//  Created by xudosom on 16/8/27.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

import UIKit

class YSEMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MWPhotoBrowserDelegate{
    let YSEImageItemCellIdentifier = "YSEImageItemCell";
    var tableView : UITableView!;
    var imageGroupList = [YSEImageGroupModel]();
    var photoes = [MWPhoto]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createMainViewControllerUI();
        
        YSERequestFetcher().p_fetchHomePage(category: "xingganmeinv", page: 1) { (requestFetcher) in
            if requestFetcher.error != nil || requestFetcher.responseObj == nil{
                return;
            }
            let list = requestFetcher.responseObj as! [YSEImageGroupModel];
            self.imageGroupList.removeAll();
            self.imageGroupList += list;
            self.tableView.reloadData();
        }
        
    }
    
    //MARK: - UI
    func createMainViewControllerUI(){
        self.view.backgroundColor = UIColor.brownColor();
        self.tableView = UITableView(frame: CGRectZero, style: .Grouped);
        self.tableView.translatesAutoresizingMaskIntoConstraints = false;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.registerClass(YSEImageItemCell.self, forCellReuseIdentifier: YSEImageItemCellIdentifier);
        self.view.addSubview(tableView);
        
        let viewsDict = ["tableView":tableView];
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: .AlignAllLeft, metrics: nil, views: viewsDict));
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: .AlignAllLeft, metrics: nil, views: viewsDict));
    }
    
    //MARK: - Delegate
    //TODO:UITableViewDelegate, UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.imageGroupList.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(YSEImageItemCellIdentifier) as? YSEImageItemCell;
        cell?.textLabel?.text = "section = \(indexPath.section)     row = \(indexPath.row)";

        let model = self.imageGroupList[indexPath.row];
        cell?.contentData = model as AnyObject;
        cell?.p_loadCell();
        return cell!;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        let selectedModel = self.imageGroupList[indexPath.row];
        self.showPhotoBrowser(selectedModel);
    }
    
    
    //TODO:MWPhotoBrowserDelegate
    
    
    
    //MARK: - web request
    
    //MARK: - handle touch
    private func showPhotoBrowser(imageGroupModel:YSEImageGroupModel){
        if Int(imageGroupModel.total_image_count) < 1 {
            return;
        }
        let displayActionButton = true;
        let displaySelectionButtons = false;
        let displayNavArrows = false;
        let enableGrid = true;
        let startOnGrid = false;
        let autoPlayOnAppear = false;
        // Create browser
        self.photoes.removeAll();
        let total_image_count = Int(imageGroupModel.total_image_count);
        for var i=1; i <= total_image_count; i+=1{
            let img_url = "\(imageGroupModel.root_img_url)/\(i).\(imageGroupModel.imge_type)";
            let url = NSURL(string: img_url);
            let photo = MWPhoto(URL: url);
            self.photoes.append(photo);
        }
//        for index in 1...total_image_count {
//            let img_url = "\(imageGroupModel.root_img_url)/\(index).\(imageGroupModel.imge_type)";
//            let url = NSURL(string: img_url);
//            let photo = MWPhoto(URL: url);
//            photoes.append(photo);
//        }
        
        let photo = MWPhoto();
        self.photoes.append(photo);
        let browser = MWPhotoBrowser(photos: self.photoes);
        browser.delegate = self;
        browser.displayActionButton = displayActionButton;
        browser.displayNavArrows = displayNavArrows;
        browser.displaySelectionButtons = displaySelectionButtons;
        browser.alwaysShowControls = displaySelectionButtons;
        browser.zoomPhotosToFill = true;
        browser.enableGrid = enableGrid;
        browser.startOnGrid = startOnGrid;
        browser.enableSwipeToDismiss = true;
        browser.autoPlayOnAppear = autoPlayOnAppear;
        browser.setCurrentPhotoIndex(0);
        let browserNC = UINavigationController(rootViewController: browser);
        browserNC.modalTransitionStyle = .CrossDissolve;
        self.navigationController?.presentViewController(browserNC, animated: true, completion: nil);
    }
    
    
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(self.photoes.count);
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        let index_int = Int(index);
        if index_int < self.photoes.count {
            return self.photoes[index_int];
        }
        return nil;
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, didDisplayPhotoAtIndex index: UInt) {
        NSLog("didDisplayPhotoAtIndex");
    }
    func photoBrowserDidFinishModalPresentation(photoBrowser: MWPhotoBrowser!) {
        NSLog("Did finish modal presentation");
        photoBrowser.dismissViewControllerAnimated(true, completion: nil);
    }


    
}
