//
//  INSDataBase.swift
//  iNews
//
//  Created by xudosom on 16/8/16.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class INSDataBase: NSObject {
    var daQueue : FMDatabaseQueue!;
    private override init() {//严格意义上的单例应该将init()方法设为私有
        let docPath = UIApplication.cw_documentsPath();
        let dbPath = docPath.stringByAppendingString("/article.db");

        var filemanager = NSFileManager.defaultManager().fileExistsAtPath(dbPath);
        NSLog("\(filemanager)");
        self.daQueue = FMDatabaseQueue(path: dbPath);
         filemanager = NSFileManager.defaultManager().fileExistsAtPath(dbPath);
        NSLog("\(filemanager)");
        
        if self.daQueue != nil {
            self.daQueue.inDatabase({ (db:FMDatabase!) in
                
            });
        }
    }
    //TODO:第一中单例写法
//    static private let instance = INSDataBase();
//    static internal func shareInstance() -> INSDataBase{
//        return instance;
//    }
    
    //第二种单例写法（struct + dispatch_once）
    struct StaticInstance {
        static var onceToken : dispatch_once_t = 0;
        static var instance : INSDataBase? = nil;
    }
    static internal func shareInstance() -> INSDataBase{
        dispatch_once(&StaticInstance.onceToken) {
            StaticInstance.instance = INSDataBase();
        };
        return StaticInstance.instance!;
    }
    

    //TODO:保存
    internal func storeArticle() ->Void{
        self.daQueue.inDatabase { (db:FMDatabase!) in

        };
        
    }
    
    internal func deleteArticle() -> Void{
        self.daQueue.inDatabase { (db:FMDatabase!) in
            
        };
    }
    
}
