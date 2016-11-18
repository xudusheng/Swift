//
//  OFORequest.swift
//  OZOCenter
//
//  Created by zhengda on 16/11/18.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit
import Foundation
public enum HttpMethodType : UInt {
    case POST
    case GET
}
class OFORequest: NSObject {
    
    static func request(httpMethod:HttpMethodType, urlString:String!, parameters:Dictionary<String, String>!, result:@escaping (_ success:Bool, _ result:AnyObject?)->Void) -> Void {
        
        let session = URLSession.shared;
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!);
        var request = URLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30);
        
        request.allHTTPHeaderFields = [
            "X-Bmob-Application-Id":"09d8a6a6235b356327d62d450435004c",
            "X-Bmob-REST-API-Key":"8fb5645bdf9c6b0a886da2e6ea86ceec",
            "Content-Type":"application/json"];
        var method = "";
        switch httpMethod {
        case HttpMethodType.POST:
            method = "POST";
            break;
        case HttpMethodType.GET:
            method = "GET";
            break;
        }
        request.httpMethod = method;
        
        let task = session.dataTask(with: request) { (data:Data?, response:URLResponse?, errorR:Error?) in
            
            if (errorR != nil){
                result(false, nil);
            }else{
                if(data != nil){
                    var jsonResult : Any?;
                    do{
                        try jsonResult = JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves);
                    }catch  {
                        NSLog("\(error)");
                    }
                    
                    if (jsonResult != nil){
                        result(true, jsonResult as AnyObject);
                    }else{
                        result(false, nil);
                    }
                }
            }
        };
        
        
        task.resume();
        
    }
    
}
