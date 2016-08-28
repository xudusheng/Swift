//
//  YSEMainViewController.swift
//  youse
//
//  Created by xudosom on 16/8/27.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

import UIKit

typealias CategoryType = (name:String, type:Int);

class YSEMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MWPhotoBrowserDelegate, MobiSageBannerAdDelegate{
    let YSEImageItemCellIdentifier = "YSEImageItemCell";
    var tableView : UITableView!;
    var page = 2;
    var imageGroupList = [[YSEImageGroupModel]]();
    var photoes = [MWPhoto]();
    
    var bannerAd : MobiSageBanner?;
    var isBannerRequestSuccess = false;
    
    var footerAd : MobiSageBanner?;
    var isFooterAdRequestSuccess = false;
    
    let categoryList:[CategoryType] = [
        (name:"xingganmeinv", type:1),
        (name:"wangyouzipai", type:2),
        (name:"gaogensiwa", type:3),
        (name:"xiyangmeinv", type:4),
        (name:"guoneimeinv", type:5),
        ];
    var category : CategoryType?;
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        self.footerAd = self.fetchBannerAd();
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createMainViewControllerUI();
        self.category = categoryList[0];
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.bannerAd = self.fetchBannerAd();
            self.headerRequest();
        });
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.footerRequest();
        });
        
        self.tableView.mj_header.beginRefreshing();
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
    
    //MARK: - Request
    func fetchBannerAd() -> MobiSageBanner {
        MobiSageManager.getInstance().setPublisherID(MS_Test_PublishID, withChannel: "AppStore", auditFlag: MS_TEST_AUDIT_FLAG);
        let ad = MobiSageBanner(bannerAdSize: .Normal, delegate: self, slotToken: MS_Test_SlotToken_Banner);
        ad.setBannerAdRefreshTime(.HalfMinute);
        ad.setBannerAdAnimeType(.Random);
        return ad;
    }

    private func headerRequest(){
        self.page = 2;
        YSERequestFetcher().p_fetchHomePage(self.category, page: 1) { (requestFetcher) in
            self.tableView.mj_header.endRefreshing();
            if requestFetcher.error != nil || requestFetcher.responseObj == nil{
                return;
            }
            let list = requestFetcher.responseObj as! [[YSEImageGroupModel]];
            self.imageGroupList.removeAll();
            self.imageGroupList += list;
            self.tableView.reloadData();
        }
    }
    
    private func footerRequest(){
        YSERequestFetcher().p_fetchHomePage(self.category, page: self.page) { (requestFetcher) in
            self.tableView.mj_footer.endRefreshing();
            if requestFetcher.error != nil || requestFetcher.responseObj == nil{
                return;
            }
            let list = requestFetcher.responseObj as! [[YSEImageGroupModel]];
            if list.last!.count > 0 {
                self.page += 1;
                var imageList = self.imageGroupList.last!;
                let newImageList = list.last!;
                imageList += newImageList;
                self.imageGroupList.removeLast();
                self.imageGroupList.append(imageList);
                self.tableView.reloadData();
            }else{
                self.tableView.mj_footer.endRefreshingWithNoMoreData();
            }
        }
    }
    //MARK: - Delegate
    //TODO:UITableViewDelegate, UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.imageGroupList.count;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let imageList = self.imageGroupList[section];
        return imageList.count;
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25;
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 && isBannerRequestSuccess && self.imageGroupList.count > 1{
            return CGRectGetHeight((self.bannerAd?.frame)!);
        }
        return CGFloat.min;
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 && isBannerRequestSuccess && self.imageGroupList.count > 1{
            return self.bannerAd;
        }
        return nil;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(YSEImageItemCellIdentifier) as? YSEImageItemCell;
        let model = self.imageGroupList[indexPath.section][indexPath.row];
        cell?.contentData = model as AnyObject;
        cell?.p_loadCell();
        return cell!;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        let selectedModel = self.imageGroupList[indexPath.section][indexPath.row];
        self.showPhotoBrowser(selectedModel);
    }
    
    //TODO:MWPhotoBrowserDelegate
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(self.photoes.count);
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        let index_int = Int(index);
        if index_int < self.photoes.count {
            let photo = self.photoes[index_int];
            if isFooterAdRequestSuccess {
                photo.caption = "  \n  ";
            };
            return photo;
        }
        return nil;
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, didDisplayPhotoAtIndex index: UInt) {
        NSLog("didDisplayPhotoAtIndex");
        let scrollView = photoBrowser.view.subviews.first as! UIScrollView;
        let captionView = scrollView.subviews.last! as UIView;
        if captionView.isKindOfClass(MWCaptionView) && isFooterAdRequestSuccess{
            captionView.userInteractionEnabled = true;
            let view = UIView(frame: self.footerAd!.bounds);
            view.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.2);
            view.addSubview(self.footerAd!);
            captionView.addSubview(view);
            NSLog("views = %@", captionView.subviews);
        }
    }
    func photoBrowserDidFinishModalPresentation(photoBrowser: MWPhotoBrowser!) {
        NSLog("Did finish modal presentation");
        photoBrowser.dismissViewControllerAnimated(true, completion: nil);
    }
    //TODO:MobiSageBannerAdDelegate
    func mobiSageBannerAdSuccessToShowAd(adBanner: MobiSageBanner!) {
        if adBanner == self.bannerAd {
            self.isBannerRequestSuccess = true;
            self.tableView.reloadData();
        }else if adBanner == self.footerAd{
            self.isFooterAdRequestSuccess = true;
        }
    }

    func mobiSageBannerLandingPageHided(adBanner: MobiSageBanner!) {
        if adBanner == self.bannerAd {
            self.isBannerRequestSuccess = false;
            self.tableView.reloadData();
        }else if adBanner == self.footerAd{
            self.isFooterAdRequestSuccess = false;
        }
    }
    
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
        self.navigationController?.pushViewController(browser, animated: true);
//        self.stackController.pushViewController(browser, animated: true);
//        self.stackController.panGestureRecognizer.direction = 0;
    }
    
    

    
    
    
}
