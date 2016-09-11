//
//  YSERequestFetcher.swift
//  youse
//
//  Created by xudosom on 16/8/27.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

import UIKit
typealias ResponseTuple = (requestFetcher:YSERequestFetcher, responseObj : AnyObject?, error : NSError?);
typealias CompleteType = ResponseTuple->Void;

let kCategoryListKey = "categoryList"
let kColorListKey = "colorList";
let kImageListKey = "imageList";

class YSERequestFetcher: NSObject {

    private var responseObj : AnyObject?;
    private var error : NSError?;

    internal func p_fetchHomePage(category:CategoryType!, page:Int!, complete:CompleteType) -> Void {
        let mURL = "http://www.3gbizhi.com/wallMV/";
        let pageSubfix = (page <= 1) ? "index.html" : "index_\(page).html";
        let url = mURL + pageSubfix;
        
        let manager = AFHTTPSessionManager();
        manager.responseSerializer = AFHTTPResponseSerializer();
        manager.GET(url, parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, respObject:AnyObject?) in
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                let result = NSString(data: respObject as! NSData, encoding: NSUTF8StringEncoding);
                let hptts = TFHpple.init(HTMLData: result?.dataUsingEncoding(NSUTF8StringEncoding));
                
                
                var categoryList = [YSECategoryModel]();
                var colorList = [YSEColorModel]();
                var imageList = [YSEImageModel]();
                let categoryItems = hptts.searchWithXPathQuery("//div[@class=\"options eS hidden\"]//a[@class=\"bt\"]");
                for categoryElement in categoryItems{
                    let element = categoryElement as! TFHppleElement;
                    let aModel = YSECategoryModel();
                    aModel.p_setTitle(element.text(), href: element.objectForKey("href"));
                    categoryList.append(aModel);
//                    NSLog("===\(element.objectForKey("href")) === \(element.text())");
                }
                
                
                let colorItems = hptts.searchWithXPathQuery("//div[@class=\"options eS hidden\"]//a[contains(@class, 'btcolor color')]");//模糊匹配
                for colorElement in colorItems{
                    let element = colorElement as! TFHppleElement;
                    let colorModel = YSEColorModel();
                    colorModel.p_setColorName(element.text(), href: element.objectForKey("href"));
                    colorList.append(colorModel);
//                    NSLog("===\(element.objectForKey("href")) === \(element.text())");
                }

                
                let imgItems = hptts.searchWithXPathQuery("//li[@class=\"ty-imgcont\"]//img");
                for imgElement in imgItems{
                    let element = imgElement as! TFHppleElement;
                    let src = String(element.objectForKey("src"));                    
                    let imageModel = YSEImageModel();
                    imageModel.p_setTitle(element.objectForKey("alt"), href: src, width: element.objectForKey("width"), height: element.objectForKey("height"));
                    imageList.append(imageModel);
//                    NSLog("===\(src) === \(element.objectForKey("alt"))");
                }
                let responseData = [
                    kCategoryListKey:categoryList,
                    kColorListKey:colorList,
                    kImageListKey:imageList
                ];
                self.responseObj = responseData;
                self.safelyCallback(complete, error: nil);
            });
            
        }) { (task:NSURLSessionDataTask?, error:NSError) in
            self.safelyCallback(complete, error: error);
        };
        
    }
    
    private func safelyCallback(complete:CompleteType, error:NSError?) -> Void {
        self.error = error;
        let responseTuple = (requestFetcher:self, responseObj : self.responseObj, error : self.error);
        if NSThread.isMainThread() {
            complete(responseTuple);
            return;
        }
        dispatch_async(dispatch_get_main_queue()) { 
            complete(responseTuple);
        }
    }
    
}
