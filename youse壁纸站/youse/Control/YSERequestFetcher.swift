//
//  YSERequestFetcher.swift
//  youse
//
//  Created by xudosom on 16/8/27.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

import UIKit
typealias ResponseTuple = (requestFetcher:YSERequestFetcher, responseObj : AnyObject?, error : NSError?);
typealias CompleteType = (ResponseTuple)->Void;

let kCategoryListKey = "categoryList"
let kColorListKey = "colorList";
let kImageListKey = "imageList";
let kNextPageHrefKey = "nextPageHref";
let kIsLastPageKey = "isLastPage";

class YSERequestFetcher: NSObject {

    fileprivate var responseObj : AnyObject?;
    fileprivate var error : NSError?;

    internal func p_fetchHomePage(classifyModel:YSEClassifyModel!, complete:CompleteType) -> Void {
        let url = self.encodeEscapesURL(classifyModel.href!);
        let manager = AFHTTPSessionManager();
        manager.responseSerializer = AFHTTPResponseSerializer();
        manager.get(url, parameters: nil, progress: nil, success: { (task:URLSessionDataTask, respObject:AnyObject?) in
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
                let result = NSString(data: respObject as! Data, encoding: String.Encoding.utf8);
                let hptts = TFHpple.init(htmlData: result?.data(using: String.Encoding.utf8));
                
                
                var categoryList = [YSECategoryModel]();
                var colorList = [YSEColorModel]();
                var imageList = [YSEImageModel]();
                let categoryItems = hptts.search(withXPathQuery: "//div[@class=\"options eS hidden\"]//a[@class=\"bt\"]");
                for categoryElement in categoryItems{
                    let element = categoryElement as! TFHppleElement;
                    let name = element.text();
                    if name == "动漫" || name == "卡通"{
                        continue;
                    }
                    let aModel = YSECategoryModel();
                    let href = element.object(forKey: "href");
                    aModel.p_setName(name, href: href);
                    categoryList.append(aModel);
//                    NSLog("===\(element.objectForKey("href")) === \(element.text())");
                }
                
                
                let colorItems = hptts.search(withXPathQuery: "//div[@class=\"options eS hidden\"]//a[contains(@class, 'btcolor color')]");//模糊匹配
                for colorElement in colorItems{
                    let element = colorElement as! TFHppleElement;
                    let name = element.text();
                    let href = element.object(forKey: "href");
                    let colorModel = YSEColorModel();
                    colorModel.p_setName(name, href: href);
                    colorList.append(colorModel);
//                    NSLog("===\(element.objectForKey("href")) === \(element.text())");
                }

                
                let imgItems = hptts.search(withXPathQuery: "//li[@class=\"ty-imgcont\"]//img");
                for imgElement in imgItems{
                    let element = imgElement as! TFHppleElement;
                    let src = String(element.object(forKey: "src"));                    
                    let imageModel = YSEImageModel();
                    imageModel.p_setTitle(element.object(forKey: "alt"), href: src, width: element.object(forKey: "width"), height: element.object(forKey: "height"));
                    imageList.append(imageModel);
//                    NSLog("===\(src) === \(element.objectForKey("alt"))");
                }
                
                let xpath_a = "//div[@id=\"pageNum\"]//span//a";
                let xpath_span = "//div[@id=\"pageNum\"]//span//span";
                let pageNumItems = hptts.search(withXPathQuery: "\(xpath_a) | \(xpath_span)");
                let lastPageElement = pageNumItems.last as! TFHppleElement;
                let nextHref = lastPageElement.object(forKey: "href");
                
                let spanElement = pageNumItems[pageNumItems.count-2]  as! TFHppleElement;
                let isLastPage = (spanElement.tagName == "span");
                
//                for pageEle in pageNumItems{
//                    let element = pageEle as! TFHppleElement;
//                    NSLog("====nodeName = \(element.tagName) = \(element.text())");
//                }
                
                let responseData = [
                    kCategoryListKey:categoryList,
                    kColorListKey:colorList,
                    kImageListKey:imageList,
                    kNextPageHrefKey:nextHref,
                    kIsLastPageKey:isLastPage,
                ];
                self.responseObj = responseData;
                self.safelyCallback(complete, error: nil);
            });
            
        }) { (task:URLSessionDataTask?, error:NSError) in
            self.safelyCallback(complete, error: error);
        };
        
    }
    
    fileprivate func safelyCallback(_ complete:CompleteType, error:NSError?) -> Void {
        self.error = error;
        let responseTuple = (requestFetcher:self, responseObj : self.responseObj, error : self.error);
        if Thread.isMainThread {
            complete(responseTuple);
            return;
        }
        DispatchQueue.main.async { 
            complete(responseTuple);
        }
    }
    
    
    func encodeEscapesURL(_ value:String) -> String {
        let str:NSString = value
        let originalString = str as CFStringRef
        let charactersToBeEscaped = "!*'();:@&=+$,/?%#[]" as CFStringRef  //":/?&=;+!@#$()',*"    //转意符号
        //let charactersToLeaveUnescaped = "[]." as CFStringRef  //保留的符号
        let result = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                             originalString,
                                                             charactersToBeEscaped,
                                                             nil,
                                                             CFStringConvertNSStringEncodingToEncoding(String.Encoding.utf8)) as NSString
        
        return result as String
    }
    
    
//    <div class="imgty" id="pageNum">
//        <span>
//                    <a class="a1">2811条</a>
//                    <a href="http://www.3gbizhi.com/lists-全部/7.html" class="a1">上一页</a>
//                    <a href="http://www.3gbizhi.com/lists-全部/">1</a>
//                    ..
//                    <a href="http://www.3gbizhi.com/lists-全部/4.html">4</a>
//                    <a href="http://www.3gbizhi.com/lists-全部/5.html">5</a>
//                    <a href="http://www.3gbizhi.com/lists-全部/6.html">6</a>
//                    <a href="http://www.3gbizhi.com/lists-全部/7.html">7</a>
//                    <span>8</span>
//                    <a href="http://www.3gbizhi.com/lists-全部/9.html">9</a>
//                    <a href="http://www.3gbizhi.com/lists-全部/10.html">10</a>
//                    <a href="http://www.3gbizhi.com/lists-全部/11.html">11</a>
//                    <a href="http://www.3gbizhi.com/lists-全部/12.html">12</a>
//                    ..
//                    <a href="http://www.3gbizhi.com/lists-全部/141.html">141</a>
//                    <a href="http://www.3gbizhi.com/lists-全部/9.html" class="a1">下一页</a>
//            </span>
//    </div>
}
