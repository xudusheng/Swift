//
//  YSEMainViewController.swift
//  youse
//
//  Created by xudosom on 16/8/27.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

import UIKit

typealias CategoryType = (chineseName:String, englishName:String, type:Int);

class YSEMainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    let INSImageItemCollectionViewCellIdentifier = "INSImageItemCollectionViewCell";
    let gap = CGFloat(5);
    var mainCollectionView : UICollectionView!;
    var page = 2;
    var imageList = [YSEImageModel]();
    
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
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.category = categoryList[0];
        self.createMainViewControllerUI();
        mainCollectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
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
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[mainCollectionView]|", options: .AlignAllLeft, metrics: nil, views: viewsDict));
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[mainCollectionView]|", options: .AlignAllLeft, metrics: nil, views: viewsDict));
        
        let rightItem = UIBarButtonItem(title: "更多", style: .Done, target: self, action: #selector(YSEMainViewController.showMenuList));
        rightItem.tintColor = UIColor.whiteColor();
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    //MARK: - Request
    private func headerRequest(){
        self.page = 2;

        YSERequestFetcher().p_fetchHomePage(self.category, page: 1) { (responseTuple) in
            self.mainCollectionView.mj_header.endRefreshing();

            if responseTuple.error != nil || responseTuple.responseObj == nil{
                return;
            }
            let result = responseTuple.responseObj as! [String:[AnyObject]];
            let fetchedImageList = result[kImageListKey] as! [YSEImageModel];
            self.imageList.removeAll();
            self.imageList += fetchedImageList;
            self.mainCollectionView.reloadData();
        }
    }
    
    private func footerRequest(){
        YSERequestFetcher().p_fetchHomePage(self.category, page: self.page) { (responseTuple) in
            self.mainCollectionView.mj_footer.endRefreshing();
            if responseTuple.error != nil || responseTuple.responseObj == nil{
                return;
            }
            let result = responseTuple.responseObj as! [String:[AnyObject]];
            let fetchedImageList = result[kImageListKey] as! [YSEImageModel];
            if fetchedImageList.count > 0 {
                self.page += 1;
                self.imageList += fetchedImageList;
                self.mainCollectionView.reloadData();
            }
        }
    }
    //MARK: - Delegate
    //TODO:UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageList.count;
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(INSImageItemCollectionViewCellIdentifier, forIndexPath: indexPath) as! INSImageItemCollectionViewCell;
        let model = self.imageList[indexPath.row]
        cell.imageModel = model;
        cell.p_loadCell();
        return cell;
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSLog("xxxxxxxxxxxxxxx");
        collectionView.deselectItemAtIndexPath(indexPath, animated: true);
        let selectedModel = self.imageList[indexPath.row];
        self.showPhotoBrowser(selectedModel);
    }
    //TODO:UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let model = imageList[indexPath.row];
        let cellWidth  = (SWIFT_DEVICE_SCREEN_WIDTH - 4*gap)/3;
        let cellHeight = self.getCellHeight(model, width: cellWidth);
        return CGSizeMake(cellWidth, cellHeight);
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(gap, gap, 0, gap);
    }
    
    //TODO:getCellHeight
    private func getCellHeight(imageModel:YSEImageModel, width:CGFloat) -> CGFloat{
        let imageHeight = CGFloat(Float(imageModel.height!)!);
        let imageWidth = CGFloat(Float(imageModel.width!)!);
        return (imageHeight * width / imageWidth);
    }
    //MARK: - web request
    
    //MARK: - handle touch
    private func showPhotoBrowser(imageModel:YSEImageModel){

        let displayActionButton = true;
        let displaySelectionButtons = false;
        let displayNavArrows = false;
        let enableGrid = true;
        let startOnGrid = false;
        let autoPlayOnAppear = false;
        // Create browser

        var img_url = imageModel.href!;
        let suffix = ".jpg";
        img_url = img_url.componentsSeparatedByString(suffix).first!;
        img_url = img_url.stringByAppendingString(suffix);
        
        let url = NSURL(string: img_url);
        let photo = MWPhoto(URL: url);
        photo.caption = imageModel.title;
        let browser = MWPhotoBrowser(photos: [photo]);
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
