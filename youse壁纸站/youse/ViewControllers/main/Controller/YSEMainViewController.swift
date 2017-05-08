//
//  YSEMainViewController.swift
//  youse
//
//  Created by xudosom on 16/8/27.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class YSEMainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MWPhotoBrowserDelegate{

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
        self.selectedClassifyModel?.p_setName("全部", href: "http://www.3gbizhi.com/lists-全部/");
        self.createMainViewControllerUI();
        mainCollectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.headerRequest();
        });
        mainCollectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.footerRequest();
        });
        mainCollectionView.mj_header.beginRefreshing();
    }
    
    //MARK: - UI
    func createMainViewControllerUI(){
        self.view.backgroundColor = UIColor.brown;
        self.title = self.selectedClassifyModel?.name;
        let flowLayout = UICollectionViewFlowLayout();
        flowLayout.minimumLineSpacing = gap;//纵向间距
        flowLayout.minimumInteritemSpacing = CGFloat.leastNormalMagnitude;//横向内边距
        
        self.mainCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout);
        mainCollectionView.translatesAutoresizingMaskIntoConstraints = false;
        mainCollectionView.delegate = self;
        mainCollectionView.dataSource = self;
        self.mainCollectionView.register(INSImageItemCollectionViewCell.self, forCellWithReuseIdentifier: INSImageItemCollectionViewCellIdentifier);
        mainCollectionView.backgroundColor = UIColor.white;
        self.view.addSubview(mainCollectionView);
        
        let viewsDict = ["mainCollectionView":mainCollectionView];
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mainCollectionView]|", options: .alignAllLeft, metrics: nil, views: viewsDict));
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mainCollectionView]|", options: .alignAllLeft, metrics: nil, views: viewsDict));
        
//        let rightItem = UIBarButtonItem(title: "更多", style: .Done, target: self, action: #selector(YSEMainViewController.showMenuList));
//        rightItem.tintColor = UIColor.whiteColor();
//        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    
    //TODO:addClassifyBarButtonItems
    fileprivate func addClassifyBarButtonItems(){
    
        var barButtonArr = [UIBarButtonItem]();
        if self.categoryList.count > 0 {
            self.categoryClassifyButton = UIButton();
            categoryClassifyButton?.frame = CGRect(x: 0, y: 0, width: 40, height: 40);
            categoryClassifyButton?.setTitle("分类", for: UIControlState());
            categoryClassifyButton?.addTarget(self, action: #selector(self.showMenuList(_:)), for: .touchUpInside)
            let categoryBarButtonItem = UIBarButtonItem(customView: categoryClassifyButton!);
            categoryBarButtonItem.tintColor = UIColor.white;
            barButtonArr.append(categoryBarButtonItem);
        }
        
        if self.colorList.count > 0 {
            self.colorClassifyButton = UIButton();
            colorClassifyButton?.frame = CGRect(x: 0, y: 0, width: 40, height: 40);
            colorClassifyButton?.setTitle("颜色", for: UIControlState());
            colorClassifyButton?.addTarget(self, action: #selector(self.showMenuList(_:)), for: .touchUpInside)
            let colorBarButtonItem = UIBarButtonItem(customView: colorClassifyButton!);
            colorClassifyButton?.tintColor = UIColor.white;
            barButtonArr.append(colorBarButtonItem);
        }
        
        if barButtonArr.count > 0 {
            self.navigationItem.rightBarButtonItems = barButtonArr;
        }
        
        self.resetBarButtonItems();
    }
    
    fileprivate func resetBarButtonItems(){
        if self.selectedClassifyModel is YSECategoryModel {
            categoryClassifyButton?.setTitle(selectedClassifyModel?.name, for: UIControlState());
            colorClassifyButton?.setTitle("颜色", for: UIControlState());
        }else{
            categoryClassifyButton?.setTitle("分类", for: UIControlState());
            colorClassifyButton?.setTitle(selectedClassifyModel?.name, for: UIControlState());
        }
    }
    //MARK: - Request
    fileprivate func headerRequest(){
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
            self.saveNextPageInfo(result:result);

            if self.categoryList.count <= 0 || self.colorList.count <= 0{
                let fetchedCategoryList = result[kCategoryListKey] as! [YSECategoryModel];
                self.categoryList += fetchedCategoryList;

                let fetchedColorList = result[kColorListKey] as! [YSEColorModel];
                self.colorList += fetchedColorList;
                
                self.addClassifyBarButtonItems();
            }

        }
    }
    
    fileprivate func footerRequest(){
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
                self.reloadPhotoBrowser();
                self.saveNextPageInfo(result: result);
            }
        }
    }
    //TODO:保存下一页的链接
    fileprivate func saveNextPageInfo(result:[String:AnyObject]){
        let nextPageHref = result[kNextPageHrefKey];
        let subfix = nextPageHref?.components(separatedBy: "/").last;
        let href = (self.selectedClassifyModel?.href)! + subfix!;
        let nextPageModel = YSEClassifyModel();
        nextPageModel.p_setName(self.selectedClassifyModel?.name, href: href);
        self.nextPageClassifyModel = nextPageModel;
        
        let isLastPage = result[kIsLastPageKey] as! Bool;
        if isLastPage{
            self.mainCollectionView.mj_footer.endRefreshingWithNoMoreData();
        }else{
            self.mainCollectionView.mj_footer.resetNoMoreData();
        }
        
    }
    
    //MARK: - Delegate
    //TODO:UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageList.count;
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: INSImageItemCollectionViewCellIdentifier, for: indexPath) as! INSImageItemCollectionViewCell;
        let model = self.imageList[indexPath.row]
        cell.imageModel = model;
        cell.p_loadCell();
        return cell;
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true);
        self.showPhotoBrowser(UInt(indexPath.row));
    }
    
    //TODO:UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = imageList[indexPath.row];
        let cellWidth  = (SWIFT_DEVICE_SCREEN_WIDTH - 4*gap)/3;
        let cellHeight = self.getCellHeight(model, width: cellWidth);
        return CGSize(width: cellWidth, height: cellHeight);
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(gap, gap, 0, gap);
    }
    
    
    //TODO:MWPhotoBrowserDelegate
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        NSLog("xxxxxxxxxxxxx");
        return UInt(self.imageList.count);
    }
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        let index_int = Int(index);
        if index_int < self.imageList.endIndex {
            let imageModel = self.imageList[index_int];
            var img_url = imageModel.href!;
            let suffix = ".jpg";
            img_url = img_url.components(separatedBy: suffix).first!;
            img_url = img_url + suffix;
            
            let url = URL(string: img_url);
            let photo = MWPhoto(url: url);
            photo.caption = imageModel.title;
            return photo;
        }
        return nil;
    }
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, didDisplayPhotoAt index: UInt) {
        if index == UInt(self.imageList.endIndex - 1) {
//            self.mainCollectionView.mj_footer.beginRefreshing();
            self.footerRequest();
        }
    }
    
    //TODO:getCellHeight
    fileprivate func getCellHeight(_ imageModel:YSEImageModel, width:CGFloat) -> CGFloat{
        let imageHeight = CGFloat(Float(imageModel.height!)!);
        let imageWidth = CGFloat(Float(imageModel.width!)!);
        return (imageHeight * width / imageWidth);
    }
    //MARK: - web request
    
    //MARK: - handle touch
    //TODO: showPhotoBrowser
    fileprivate func showPhotoBrowser(_ currentPhotoIndex:UInt){
        let displayActionButton = true;
        let displaySelectionButtons = false;
        let displayNavArrows = false;
        let enableGrid = true;
        let startOnGrid = false;
        let autoPlayOnAppear = false;
        // Create browser
        let browser = MWPhotoBrowser();
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
        browser.setCurrentPhotoIndex(currentPhotoIndex);
        self.navigationController?.pushViewController(browser, animated: true);
    }
    
    //reload photoBrowser
    fileprivate func reloadPhotoBrowser(){
        if (self.navigationController?.viewControllers.count > 1) {
            let photoBrowserVC = self.navigationController?.viewControllers.last;
            if photoBrowserVC is MWPhotoBrowser {
                let photoBrowser = photoBrowserVC as! MWPhotoBrowser;
                photoBrowser.reloadData();
            }
        }
    }
    
    //TODO:showMenu
    @objc fileprivate func showMenuList(_ button:UIButton?){
        let list : [YSEClassifyModel] = (button == self.categoryClassifyButton) ? self.categoryList : self.colorList;
        if menuView == nil {
            self.menuView = YSEMenuView(frame: CGRect.zero);
            menuView?.callBack = {
                (classifyModel : YSEClassifyModel) -> Void in
                self.selectedClassifyModel = classifyModel;
                self.title = self.selectedClassifyModel?.name;
                self.mainCollectionView.mj_header.beginRefreshing();
                self.showMenuList(nil);
            };
            self.view.addSubview(menuView!);
        }
        
        let frame = mainCollectionView.frame
        if menuView!.frame.height < 1 {
            menuView!.categoryList = list;
            menuView?.p_show(backView_finalFrame: frame);
        }else{
            let new_frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: CGFloat.leastNormalMagnitude);
            menuView?.p_hide(backView_finalFrame:new_frame);
        }
        self.resetBarButtonItems();
    }
}
