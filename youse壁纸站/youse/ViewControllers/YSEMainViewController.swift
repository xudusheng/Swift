//
//  YSEMainViewController.swift
//  youse
//
//  Created by xudosom on 16/8/27.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

import UIKit

class YSEMainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    let INSImageItemCollectionViewCellIdentifier = "INSImageItemCollectionViewCell";
    let gap = CGFloat(5);
    var mainCollectionView : UICollectionView!;
    var imageList = [YSEImageModel]();
    
    var menuView : YSEMenuView?;
    
    var categoryList = [YSECategoryModel]();
    var categoryClassifyButton : UIButton?;
    var colorList = [YSEColorModel]();
    var colorClassifyButton : UIButton?;
    
    var selectedClassifyModel : YSEClassifyModel?;//第一页、当前被选中的分类model
    var nextPageClassifyModel : YSEClassifyModel?;//下一页
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.category = categoryList[0];
        self.selectedClassifyModel = YSECategoryModel();
        self.selectedClassifyModel?.p_setName("美女", href: "http://www.3gbizhi.com/lists-全部/");
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
        self.title = self.selectedClassifyModel?.name;
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
        
//        let rightItem = UIBarButtonItem(title: "更多", style: .Done, target: self, action: #selector(YSEMainViewController.showMenuList));
//        rightItem.tintColor = UIColor.whiteColor();
//        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    
    //TODO:addClassifyBarButtonItems
    private func addClassifyBarButtonItems(){
    
        var barButtonArr = [UIBarButtonItem]();
        if self.categoryList.count > 0 {
            self.categoryClassifyButton = UIButton();
            categoryClassifyButton?.frame = CGRectMake(0, 0, 40, 40);
            categoryClassifyButton?.setTitle("分类", forState: .Normal);
            categoryClassifyButton?.addTarget(self, action: #selector(self.showMenuList(_:)), forControlEvents: .TouchUpInside)
            let categoryBarButtonItem = UIBarButtonItem(customView: categoryClassifyButton!);
            categoryBarButtonItem.tintColor = UIColor.whiteColor();
            barButtonArr.append(categoryBarButtonItem);
        }
        
        if self.colorList.count > 0 {
            self.colorClassifyButton = UIButton();
            colorClassifyButton?.frame = CGRectMake(0, 0, 40, 40);
            colorClassifyButton?.setTitle("颜色", forState: .Normal);
            colorClassifyButton?.addTarget(self, action: #selector(self.showMenuList(_:)), forControlEvents: .TouchUpInside)
            let colorBarButtonItem = UIBarButtonItem(customView: colorClassifyButton!);
            colorClassifyButton?.tintColor = UIColor.whiteColor();
            barButtonArr.append(colorBarButtonItem);
        }
        
        if barButtonArr.count > 0 {
            self.navigationItem.rightBarButtonItems = barButtonArr;
        }
        
        self.resetBarButtonItems();
    }
    
    private func resetBarButtonItems(){
        if self.selectedClassifyModel is YSECategoryModel {
            categoryClassifyButton?.setTitle(selectedClassifyModel?.name, forState: .Normal);
            colorClassifyButton?.setTitle("颜色", forState: .Normal);
        }else{
            categoryClassifyButton?.setTitle("分类", forState: .Normal);
            colorClassifyButton?.setTitle(selectedClassifyModel?.name, forState: .Normal);
        }
    }
    //MARK: - Request
    private func headerRequest(){
        YSERequestFetcher().p_fetchHomePage(classifyModel: self.selectedClassifyModel) { (responseTuple) in
            self.mainCollectionView.mj_header.endRefreshing();
            
            if responseTuple.error != nil || responseTuple.responseObj == nil{
                return;
            }
            let result = responseTuple.responseObj as! [String:AnyObject];
            let fetchedImageList = result[kImageListKey] as! [YSEImageModel];
            self.imageList.removeAll();
            self.imageList += fetchedImageList;
            self.mainCollectionView.reloadData();
            self.saveNextPageInfo(nextPageHref: result[kNextPageHrefKey] as? String);

            if self.categoryList.count <= 0 || self.colorList.count <= 0{
                let fetchedCategoryList = result[kCategoryListKey] as! [YSECategoryModel];
                self.categoryList += fetchedCategoryList;

                let fetchedColorList = result[kColorListKey] as! [YSEColorModel];
                self.colorList += fetchedColorList;
                
                self.addClassifyBarButtonItems();
            }

        }
    }
    
    private func footerRequest(){
        if nextPageClassifyModel == nil {
            self.mainCollectionView.mj_footer.endRefreshing();
            return;
        }
        YSERequestFetcher().p_fetchHomePage(classifyModel: self.nextPageClassifyModel) { (responseTuple) in
            self.mainCollectionView.mj_footer.endRefreshing();
            if responseTuple.error != nil || responseTuple.responseObj == nil{
                return;
            }
            let result = responseTuple.responseObj as! [String:AnyObject];
            let fetchedImageList = result[kImageListKey] as! [YSEImageModel];
            if fetchedImageList.count > 0 {
                self.imageList += fetchedImageList;
                self.mainCollectionView.reloadData();
                self.saveNextPageInfo(nextPageHref: result[kNextPageHrefKey] as? String);
                let isLastPage = result[kIsLastPageKey] as! Bool;
                if isLastPage{
                    self.mainCollectionView.mj_footer.endRefreshingWithNoMoreData();
                }
            }
        }
    }
    //TODO:保存下一页的链接
    private func saveNextPageInfo(nextPageHref nextPageHref:String?){
        let subfix = nextPageHref?.componentsSeparatedByString("/").last;
        let href = (self.selectedClassifyModel?.href)! + subfix!;
        let nextPageModel = YSEClassifyModel();
        nextPageModel.p_setName(self.selectedClassifyModel?.name, href: href);
        self.nextPageClassifyModel = nextPageModel;
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
    @objc private func showMenuList(button:UIButton?){
        let list : [YSEClassifyModel] = (button == self.categoryClassifyButton) ? self.categoryList : self.colorList;
        if menuView == nil {
            self.menuView = YSEMenuView(frame: CGRectZero);
            menuView?.callBack = {
                (classifyModel : YSEClassifyModel) -> Void in
                self.selectedClassifyModel = classifyModel;
                self.title = self.selectedClassifyModel?.name;
                self.mainCollectionView.mj_header.beginRefreshing();
                self.showMenuList(nil);
            };
            self.view.addSubview(menuView!);
        }
        menuView!.categoryList = list;

        
        let frame = mainCollectionView.frame
        if CGRectGetHeight(menuView!.frame) < 1 {
            menuView?.p_show(backView_finalFrame: frame);
        }else{
            let new_frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), CGFloat.min);
            menuView?.p_hide(backView_finalFrame:new_frame);
        }
        
        self.resetBarButtonItems();
    }
}
