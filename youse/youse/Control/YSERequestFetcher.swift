//
//  YSERequestFetcher.swift
//  youse
//
//  Created by xudosom on 16/8/27.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

import UIKit

class YSERequestFetcher: NSObject {
    let requestRootUrl = "http://www.169bb.com/";
    typealias YSERequestComplete = (requestFetcher:YSERequestFetcher) -> Void;
    var responseObj : AnyObject?;
    var error : NSError?;
    
    
    internal func p_fetchHomePage(category:CategoryType!, page:Int!, complete:YSERequestComplete) -> Void {
        let url = "\(requestRootUrl)/\(category.name)/list_\(category.type)_\(page).html" ;
        
        let manager = AFHTTPSessionManager();
        manager.responseSerializer = AFHTTPResponseSerializer();
        
        manager.GET(url, parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, respObject:AnyObject?) in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                let enc = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
                var result = NSString(data: respObject as! NSData, encoding: enc);
                result = result?.stringByReplacingOccurrencesOfString("charset=gb2312", withString: "charset=utf-8");
                
                var recommendList : [YSEImageGroupModel]?;
                let hptts = TFHpple.init(HTMLData: result?.dataUsingEncoding(NSUTF8StringEncoding));
                if page == 1{
                    let recommendItems = hptts.searchWithXPathQuery("//ul[@class=\"product03\"]//a");
                    recommendList = self.transferToModels(items: recommendItems, category: category);
                }
                let items = hptts.searchWithXPathQuery("//ul[@class=\"product01\"]//a");
                let imageModels = self.transferToModels(items: items, category: category);
                if recommendList != nil{
                    self.responseObj = [recommendList!, imageModels];
                }else{
                    self.responseObj = [imageModels];
                }
                self.safelyCallback(complete, error: nil);
            });
            
        }) { (task:NSURLSessionDataTask?, error:NSError) in
            self.safelyCallback(complete, error: error);
        };
        
        complete(requestFetcher: self);
    }
    
    func transferToModels(items items:NSArray, category:CategoryType!) -> [YSEImageGroupModel] {
        var imageModels = [YSEImageGroupModel]();
        for item in items{
            let element_a = item as! TFHppleElement;
            let info = self.separateElement(element_a);
            let model = YSEImageGroupModel();
            model.category = category.name;
            model.db_id = info.db_id;
            model.title = info.title;
            model.href = info.href;
            model.item_img_url = info.item_img_url;
            let newModel = YSEDataBase.shareInstance().storeOrUpdate(imageGroupModel: model);
            imageModels.append(newModel);
        }
        return imageModels;
    }
    //TODO:分离出id，href等
    func separateElement(element_a:TFHppleElement) -> (db_id:String!, title:String!, href:String!, item_img_url:String!) {

        let element_img = element_a.firstChildWithTagName("img");
        let element_p = element_a.firstChildWithTagName("p");
        var href = element_a.objectForKey("href");
        var imageUrl = element_img.objectForKey("src");
        var title = element_p.text();
        var db_id : String?;

        var href_sep = href.componentsSeparatedByString("/");
        if href_sep.count > 2 {
            let html = href_sep.last;
            let html_sep = html?.componentsSeparatedByString(".");
            let id = html_sep?.first;
            href_sep.removeLast();
            let month = href_sep.last;
            href_sep.removeLast();
            let year = href_sep.last;
            db_id = year! + "/" + month! + "/" + id!;
        }
        href = (href != nil) ? href : "";
        imageUrl = (imageUrl != nil) ? imageUrl : "";
        title = (title != nil) ? title : "";
        db_id = (db_id != nil) ? db_id : "";
        
        return (db_id, title, href, imageUrl);
    }
    
    
    internal func p_fetchFirstImagePage(imageGroupModel:YSEImageGroupModel, complete:YSERequestComplete) -> Void {
        let manager = AFHTTPSessionManager();
        manager.responseSerializer = AFHTTPResponseSerializer();
        manager.GET(imageGroupModel.href, parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, respObject:AnyObject?) in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                let enc = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
                var result = NSString(data: respObject as! NSData, encoding: enc);
                result = result?.stringByReplacingOccurrencesOfString("charset=gb2312", withString: "charset=utf-8");
                
                let hptts = TFHpple.init(HTMLData: result?.dataUsingEncoding(NSUTF8StringEncoding));
                let pagelist = hptts.searchWithXPathQuery("//ul[@class=\"pagelist\"]//a");
                let totalPageElement = pagelist.first as? TFHppleElement;
                var model = imageGroupModel;
                if totalPageElement != nil{
                    var totalPage = totalPageElement?.text();
                    let characters = (totalPage?.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet))! as NSArray;
                    totalPage = characters.componentsJoinedByString("");
                    model.total_page = totalPage!;
                    if Int(model.total_page) > 0 {
                        model.has_get_total_page = YSEBOOLString.TRUE;
                        model = YSEDataBase.shareInstance().storeOrUpdate(imageGroupModel: model);
                    }
                }
                self.responseObj = model;
                self.safelyCallback(complete, error: nil);
            });
            }) { (task:NSURLSessionDataTask?, error:NSError) in
                self.safelyCallback(complete, error: error);
        };
    }
    
    internal func p_fetchLastImagePage(imageGroupModel:YSEImageGroupModel, complete:YSERequestComplete) -> Void {
        let manager = AFHTTPSessionManager();
        manager.responseSerializer = AFHTTPResponseSerializer();
        
        let url = imageGroupModel.href.stringByReplacingOccurrencesOfString(imageGroupModel.db_id, withString: imageGroupModel.db_id + "_" + imageGroupModel.total_page);
        manager.GET(url, parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, respObject:AnyObject?) in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                let enc = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
                var result = NSString(data: respObject as! NSData, encoding: enc);
                result = result?.stringByReplacingOccurrencesOfString("charset=gb2312", withString: "charset=utf-8");
                
                let hptts = TFHpple.init(HTMLData: result?.dataUsingEncoding(NSUTF8StringEncoding));
                let pagelist = hptts.searchWithXPathQuery("//div[@class=\"big_img\"]//img");
                let element_lastImage = pagelist.last as? TFHppleElement;
                var model = imageGroupModel;
                if element_lastImage != nil{
                    let lastImgInfo = self.separateElement(element_lastImage);
                    if (Int(lastImgInfo.total_image_count) > 0 && lastImgInfo.imge_type.characters.count > 0 && lastImgInfo.root_img_url.characters.count > 0){
                        model.total_image_count = lastImgInfo.total_image_count;
                        model.imge_type =  lastImgInfo.imge_type;
                        model.root_img_url = lastImgInfo.root_img_url;
                        model.is_ready_toshow = YSEBOOLString.TRUE;
                        model = YSEDataBase.shareInstance().storeOrUpdate(imageGroupModel: model);
                    }
                }
                self.responseObj = model;
                self.safelyCallback(complete, error: nil);
            });
        }) { (task:NSURLSessionDataTask?, error:NSError) in
            self.safelyCallback(complete, error: error);
        };
    }
    
    //TODO:分离出root_img_url，imge_type, total_image_count等
    func separateElement(element_lastImage:TFHppleElement!) -> (total_image_count:String!, imge_type:String!, root_img_url:String!) {
        let src = element_lastImage.objectForKey("src");
        var src_sep = src.componentsSeparatedByString("/");
        var total_image_count = "";
        var image_type = "";
        var root_img_url = "";
        if src_sep.count > 1 {
            let countAndImageType = src_sep.last;
            let countAndImageType_sep = countAndImageType?.componentsSeparatedByString(".");
            total_image_count = (countAndImageType_sep?.first)!;
            image_type = (countAndImageType_sep?.last)!;
            src_sep.removeLast();
            let src_sep_NSArray = src_sep as NSArray;
            root_img_url = src_sep_NSArray.componentsJoinedByString("/");
        }
        return (total_image_count, image_type, root_img_url);
    }
    
    private func safelyCallback(complete:YSERequestComplete, error:NSError?) -> Void {
        self.error = error;
        if NSThread.isMainThread() {
            complete(requestFetcher: self);
            return;
        }
        dispatch_async(dispatch_get_main_queue()) { 
            complete(requestFetcher: self);
        }
    }
    
}
