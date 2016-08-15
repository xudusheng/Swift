//
//  XDSAdsageViewController.swift
//  XDSSwift
//
//  Created by zhengda on 16/8/15.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class XDSAdsageViewController: XDSRootViewController, UITableViewDelegate, UITableViewDataSource, MobiSageBannerAdDelegate, MobiSageFactoryAdDelegate{
    var _tableView:UITableView!;
    var _dateList : [AnyObject]!;
    
    var _adDict : NSMutableDictionary!;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.adsageViewControllerDataInit();
        self.createAdsageViewControllerUI();
    }

    //MARK: - UI相关
    func createAdsageViewControllerUI(){
        _tableView = UITableView(frame: self.view.bounds, style: .Grouped);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.view.addSubview(_tableView);
        
        self.navigationController?.navigationBar.translucent = false;
        self.bannerAd();
//        self.nativeAd();//信息流广告
    }
    
    //MARK: - 代理方法
    //UITableViewDelegate, UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _dateList.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let obj = _dateList[indexPath.row] as AnyObject;
        if obj.isKindOfClass(NSString.self) {
            return self .tableView(tableView, indePath: indexPath);
        }
        
        var cell = tableView.dequeueReusableCellWithIdentifier("xxxxx");
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "xxxxx");
        }
        let dic = obj as! NSDictionary;
        cell?.textLabel?.text = dic["title"] as? String;
        cell?.detailTextLabel?.text = dic["description"] as? String;
        return cell!;
    }
    
    func tableView(tableView:UITableView, indePath:NSIndexPath) -> UITableViewCell {
        let CellIdentifier = "ADCellIdentifier";
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier);
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: CellIdentifier);
        }
        var adNative = cell?.viewWithTag(100) as? MobiSageNative;
        adNative?.removeFromSuperview();
        adNative = _adDict.objectForKey(String(indePath.row)) as? MobiSageNative;
        adNative?.tag = 100;
        cell?.addSubview(adNative!);
        return cell!;
    }

    
    //TODO:MobiSageBannerAdDelegate
    //TODO:MobiSageFactoryAdDelegate
    //TODO:SmtaranAdFactoryDelegate

    func mobiSageFactoryAdSuccessToRequest(adFactory: MobiSageFactory!) {
        NSLog("-------信息流广告请求成功");

    }
    func mobiSageFactoryAdFaildToRequest(adFactory: MobiSageFactory!, withError error: NSError!) {
        NSLog("------- 信息流广告请求失败：%@",error);
    }

    
    //MARK: - 网络请求
    func bannerAd() -> Void {
            MobiSageManager.getInstance().setPublisherID(MS_Test_PublishID, withChannel: "AppStore", auditFlag: MS_TEST_AUDIT_FLAG);
            let adBanner = MobiSageBanner(bannerAdSize: .Normal, delegate: nil, slotToken: MS_Test_SlotToken_Banner);
            adBanner.setBannerAdRefreshTime(.HalfMinute);
            adBanner.setBannerAdAnimeType(.Random);
            _tableView.tableFooterView = adBanner;
    }
    
    func nativeAd() -> Void {
        MobiSageManager.getInstance().setPublisherID(MS_Test_PublishID, auditFlag: nil);    
        let nativeGroup = MobiSageFactory();
        nativeGroup.delegate = self;
        nativeGroup.capacity = 2;//请求广告数量
        nativeGroup.requestWithSize(CGSizeMake(self.view.frame.size.width-20, 50), slotToken: MS_Test_SlotToken_Native) { (adViews : [AnyObject]!) in
            
            var page = 0;
            for anAdView in adViews{
                let index = (Int(arc4random())%(self._dateList.count/adViews.count-1)) + page;
                page += self._dateList.count/adViews.count;
                self._adDict.setValue(anAdView, forKey: String(index));
                self._dateList.insert("广告", atIndex: index);
            }
            self._tableView .reloadData();
        }
    }
    //MARK: - 事件响应处理
    
    //MARK: - 其他私有方法
    
    //MARK: - 内存管理相关
    func adsageViewControllerDataInit(){
        let dateList = [
        ["title":"熟睡的汪星人","logo":"http://pic.qiushibaike.com/system/avtnew/1458/14588028/medium/20140808161925.jpg","description":"小明跟小华到动物园玩，进门时，小明指着小华对看门人说：“看清楚喔！等会儿出来，别说我偷了你们的猴子!"],
        ["title":"不会飞翔的鸟","logo":"http://pic.qiushibaike.com/system/avtnew/872/8723279/medium/20140322180009.jpg","description":"有个人第一次在集市上卖冰棍，不好意思叫卖，旁边有一个人正高声喊：“卖冰棍”，他只好喊道：“我也是."],
        ["title":"芳草无情斜阳外","logo":"http://pic.qiushibaike.com/system/avtnew/1571/15715835/medium/20140507062511.jpg","description":"父亲对女儿的男友严厉地说：“你每天只带我女儿看电影，就不能做点别的事？”年轻人又惊又喜：“您是说可以做其它的事儿了吗？"],
        ["title":"我就是萌小妹","logo":"http://pic.qiushibaike.com/system/avtnew/1857/18572231/medium/20140731102727.jpg","description":"学了点国语的老外。早晨和女秘书打招呼“你吗好？”小姐瞪了他一眼，他一楞，马上又对她说：“妈，你好！”"],
        ["title":"阳春白雪yuyu","logo":"http://pic.qiushibaike.com/system/avtnew/1697/16976039/medium/20140901132119.jpg","description":"有两只小鸟看见一个猎人正在瞄准它们，一只说，你保护现场我去叫警察！"]];
        _dateList = dateList;

        _adDict = NSMutableDictionary(capacity: 0);
    }

    
}
