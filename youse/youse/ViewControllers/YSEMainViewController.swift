//
//  YSEMainViewController.swift
//  youse
//
//  Created by xudosom on 16/8/27.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

import UIKit

typealias CategoryType = (chineseName:String, englishName:String, type:Int);

class YSEMainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MWPhotoBrowserDelegate, MobiSageBannerAdDelegate{
    let YSEImageItemCellIdentifier = "YSEImageItemCell";
    let INSImageItemCollectionViewCellIdentifier = "INSImageItemCollectionViewCell";
    let gap = CGFloat(5);
    var mainCollectionView : UICollectionView!;
    var page = 2;
    var imageGroupList = [[YSEImageGroupModel]]();
    var photoes = [MWPhoto]();
    
    var bannerAd : MobiSageBanner?;
    var isBannerRequestSuccess = false;
    
    var footerAd : MobiSageBanner?;
    var isFooterAdRequestSuccess = false;
    
    var menuView : YSEMenuView?;
    
    let categoryList:[CategoryType] = [
        (chineseName:"性感美女", englishName:"xingganmeinv", type:1),
        (chineseName:"网友自拍", englishName:"wangyouzipai", type:2),
        (chineseName:"高跟丝袜", englishName:"gaogensiwa", type:3),
        (chineseName:"外国美女", englishName:"xiyangmeinv", type:4),
        (chineseName:"国内美女", englishName:"guoneimeinv", type:5),
        ];
    var category : CategoryType?;
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        self.footerAd = self.fetchBannerAd();
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.category = categoryList[0];
        self.createMainViewControllerUI();
        mainCollectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.bannerAd = self.fetchBannerAd();
            self.headerRequest();
        });
        mainCollectionView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.footerRequest();
        });
        mainCollectionView.mj_header.beginRefreshing();
    }
    
    //MARK: - UI
    func createMainViewControllerUI(){
        self.view.backgroundColor = UIColor.brownColor();
        self.title = category?.chineseName;
        let flowLayout = UICollectionViewFlowLayout();
        flowLayout.minimumLineSpacing = gap;//纵向间距
        flowLayout.minimumInteritemSpacing = CGFloat.min;//横向内边距
        
        self.mainCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout);
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false;
        mainCollectionView.delegate = self;
        mainCollectionView.dataSource = self;
        self.mainCollectionView.registerClass(INSImageItemCollectionViewCell.self, forCellWithReuseIdentifier: INSImageItemCollectionViewCellIdentifier);
        mainCollectionView.backgroundColor = UIColor.whiteColor();
        self.view.addSubview(mainCollectionView);
        
        let viewsDict = ["mainCollectionView":mainCollectionView];
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[mainCollectionView]|",
                                                                                options: .AlignAllLeft,
                                                                                metrics: nil,
                                                                                views: viewsDict));
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[mainCollectionView]|",
                                                                                options: .AlignAllLeft,
                                                                                metrics: nil,
                                                                                views: viewsDict));
        
        let rightItem = UIBarButtonItem(title: "更多", style: .Done, target: self, action: #selector(YSEMainViewController.showMenuList));
        rightItem.tintColor = UIColor.whiteColor();
        self.navigationItem.rightBarButtonItem = rightItem;
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
            self.mainCollectionView.mj_header.endRefreshing();

            if requestFetcher.error != nil || requestFetcher.responseObj == nil{
                return;
            }
            let list = requestFetcher.responseObj as! [[YSEImageGroupModel]];
            self.imageGroupList.removeAll();
            self.imageGroupList += list;
            self.mainCollectionView.reloadData();
        }
    }
    
    private func footerRequest(){
        YSERequestFetcher().p_fetchHomePage(self.category, page: self.page) { (requestFetcher) in
            self.mainCollectionView.mj_footer.endRefreshing();
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
                self.mainCollectionView.reloadData();
            }else{
                self.mainCollectionView.mj_footer.endRefreshingWithNoMoreData();
            }
        }
    }
    //MARK: - Delegate
    //TODO:UICollectionViewDelegate, UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.imageGroupList.count;
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let imageList = self.imageGroupList[section];
        return imageList.count;
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(INSImageItemCollectionViewCellIdentifier, forIndexPath: indexPath) as! INSImageItemCollectionViewCell;
        let model = self.imageGroupList[indexPath.section][indexPath.row];
        cell.imageModel = model;
        cell.p_loadCell();
        return cell;
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSLog("xxxxxxxxxxxxxxx");
        collectionView.deselectItemAtIndexPath(indexPath, animated: true);
        let selectedModel = self.imageGroupList[indexPath.section][indexPath.row];
        self.showPhotoBrowser(selectedModel);
    }
    //TODO:UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let model = imageGroupList[indexPath.section][indexPath.row];
        let cellWidth  = (SWIFT_DEVICE_SCREEN_WIDTH - 3*gap)/2;
        let cellHeight = self.getCellHeight(model, width: cellWidth);
        return CGSizeMake(cellWidth, cellHeight);
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(gap, gap, 0, gap);
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
        let lasetView = scrollView.subviews.last! as UIView;
        let adHeight = CGRectGetHeight(footerAd!.frame);
        if isFooterAdRequestSuccess && adHeight > 1 && lasetView.isKindOfClass(MWCaptionView){
            let captionView = lasetView as! MWCaptionView;
            captionView.userInteractionEnabled = true;
            captionView.barTintColor = UIColor.clearColor();
            captionView.tintColor = UIColor.clearColor();
            captionView.setBackgroundImage(UIImage(named: "blankLine"), forToolbarPosition: .Any, barMetrics: .Default);
            captionView.setShadowImage(UIImage(), forToolbarPosition: .Any);
            
            let captionViewHeight = CGRectGetHeight(captionView.frame);
            let view = UIView(frame: self.footerAd!.frame);
            var viewFrame = view.frame;
            viewFrame.origin.y = captionViewHeight - adHeight;
            view.frame = viewFrame;
            view.addSubview(self.footerAd!);
            captionView.addSubview(view);
            NSLog("frame = %@", NSStringFromCGRect(footerAd!.frame));
        }
    }
    func photoBrowserDidFinishModalPresentation(photoBrowser: MWPhotoBrowser!) {
        NSLog("Did finish modal presentation");
        photoBrowser.dismissViewControllerAnimated(true, completion: nil);
    }
    //TODO:MobiSageBannerAdDelegate
    func mobiSageBannerAdSuccessToShowAd(adBanner: MobiSageBanner!) {
        if adBanner == self.bannerAd {
            let adHeight = CGRectGetHeight(bannerAd!.frame);
            self.isBannerRequestSuccess = (adHeight > 1);
            self.mainCollectionView.reloadData();
        }else if adBanner == self.footerAd{
            let adHeight = CGRectGetHeight(footerAd!.frame);
            self.isFooterAdRequestSuccess =  (adHeight > 1);
        }
    }
    func mobiSageBannerLandingPageHided(adBanner: MobiSageBanner!) {
        if adBanner == self.bannerAd {
            self.isBannerRequestSuccess = false;
            self.mainCollectionView.reloadData();
        }else if adBanner == self.footerAd{
            self.isFooterAdRequestSuccess = false;
        }
    }
    
    //TODO:getCellHeight
    private func getCellHeight(imageModel:YSEImageGroupModel, width:CGFloat) -> CGFloat{
        let imageHeight = CGFloat(Float(imageModel.item_img_height)!);
        let imageWidth = CGFloat(Float(imageModel.item_img_width)!);
        return (imageHeight * width / imageWidth);
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
        let total_image_count = Int(imageGroupModel.total_image_count)!;
        for index in 1...total_image_count {
            let img_url = "\(imageGroupModel.root_img_url)/\(index).\(imageGroupModel.imge_type)";
            let url = NSURL(string: img_url);
            let photo = MWPhoto(URL: url);
            self.photoes.append(photo);
        }
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
    }
    
    
    //TODO:showMenu
    @objc private func showMenuList(){
        
        if menuView == nil {
            self.menuView = YSEMenuView(frame: CGRectZero);
            menuView!.categoryList = categoryList;
            menuView?.callBack = {
                (category : CategoryType) -> Void in
                self.category = category;
                self.title = self.category!.chineseName;
                self.mainCollectionView.mj_header.beginRefreshing();
                self.showMenuList();
            };
            self.view.addSubview(menuView!);
        }
        
        let frame = mainCollectionView.frame
        if CGRectGetHeight(menuView!.frame) < 1 {
            menuView?.p_show(backView_finalFrame: frame);
        }else{
            let new_frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGFloat.min);
            menuView?.p_hide(backView_finalFrame:new_frame);
        }
    }
}
