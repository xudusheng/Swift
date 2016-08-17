//
//  INSDataBase.swift
//  iNews
//
//  Created by xudosom on 16/8/16.
//  Copyright © 2016年 zhengda. All rights reserved.
//

import UIKit

class INSDataBase: NSObject {
    static let tableName = "t_article";
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
                //创建表
                if !db.tableExists(INSDataBase.tableName){
                    let createSql = "create table \(INSDataBase.tableName) (articleId NOT NULL PRIMARY KEY, articleType TEXT, publicDate TEXT, title TEXT, summary TEXT, href TEXT, content TEXT)";
                    let result = db.executeStatements(createSql);
                    if (result){
                        NSLog("创建表成功");
                    }else{
                        NSLog("创建表失败");
                    }
                }
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
    internal func storeArticle(articleModel:INSArticleModel) ->Void{
        self.daQueue.inDatabase { (db:FMDatabase!) in
            let insertSql = "insert into \(INSDataBase.tableName) (articleId, articleType, publicDate, title, summary, href, content) values (?, ?, ?, ?, ?, ?, ?)";
            let argumentinArray = [articleModel.articleId, articleModel.articleType, articleModel.publicDate, articleModel.title, articleModel.summary, articleModel.href, articleModel.content]
            let result = db.executeQuery(insertSql, withArgumentsInArray: argumentinArray);
            if result != nil{
                NSLog("数据插入成功");
                result.close();
            }else{
                NSLog("数据插入失败");
            }
        };
        
    }
    
    //TODO:查询
    internal func fetchArticles(limit:UInt){
//        let sql = "SELECT * FROM \(INSDataBase.tableName) ORDER BY publicDate DESC LIMIT \(limit)";
        let sql = "SELECT * FROM \(INSDataBase.tableName)";
        self.daQueue.inDatabase { (db:FMDatabase!) in
            let result = db.executeQuery(sql, withArgumentsInArray: []);
            while result.next(){
                NSLog("title = \(result.stringForColumn("title"))");
            }
        }
    }
    internal func deleteArticle() -> Void{
        self.daQueue.inDatabase { (db:FMDatabase!) in
            
        };
    }
    
}
