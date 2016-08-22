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
        print("dbPath = \(dbPath)");

        var filemanager = NSFileManager.defaultManager().fileExistsAtPath(dbPath);
        NSLog("\(filemanager)");
        self.daQueue = FMDatabaseQueue(path: dbPath);
         filemanager = NSFileManager.defaultManager().fileExistsAtPath(dbPath);
        NSLog("\(filemanager)");
        
        if self.daQueue != nil {

            self.daQueue.inDatabase({ (db:FMDatabase!) in
                //创建表
                if !db.tableExists(INSDataBase.tableName){
                    let createSql = "create table if not exists \(INSDataBase.tableName) (articleId NOT NULL PRIMARY KEY, articleType TEXT, publicDate TEXT, title TEXT, summary TEXT, href TEXT, content TEXT)";
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
    

    //TODO:插入一条数据
    internal func storeArticle(articleModel:INSArticleModel) ->Void{

        self.daQueue.inDatabase { (db:FMDatabase!) in
            
            //                [db intForQuery:@"SELECT COUNT (id) FROM article WHERE id = ?", article.articleId];
            
            self.generateSQLForUpdatingArticle(articleModel) { (sql: NSString, arguments: NSArray) -> () in
                
            };
            
            
            let insertSql = "insert into \(INSDataBase.tableName) (articleId, articleType, publicDate, title, summary, href, content) values (?, ?, ?, ?, ?, ?, ?)";
            let argumentinArray = [articleModel.articleId, articleModel.articleType, articleModel.publicDate, articleModel.title, articleModel.summary, articleModel.href, articleModel.content]
            let result = db.executeUpdate(insertSql, withArgumentsInArray: argumentinArray);
            if result{
                NSLog("数据插入成功");
            }else{
                NSLog("数据插入失败");
            }
        };
    }
    
    private func generateSQLForUpdatingArticle(article:INSArticleModel, completion:(sql:NSString, arguments:NSArray) -> ()){
        if article.articleId == nil {
            return completion(sql: "", arguments: []);
        }
        let columns = NSMutableArray();
        let arguments = NSMutableArray();
        
        columns.addObject("articleId = ?");
        arguments.addObject(article.articleId);
        if article.articleType != nil {
            columns.addObject("articleType = ?");
            arguments.addObject(article.articleType);
        }
        if article.publicDate != nil {
            columns.addObject("publicDate = ?");
            arguments.addObject(article.publicDate);
        }
        if article.title != nil {
            columns.addObject("title = ?");
            arguments.addObject(article.title);
        }
        if article.summary != nil {
            columns.addObject("summary = ?");
            arguments.addObject(article.summary);
        }
        if article.href != nil {
            columns.addObject("href = ?");
            arguments.addObject(article.href);
        }
        if article.content != nil {
            columns.addObject("content = ?");
            arguments.addObject(article.content);
        }

        let sql = "update \(INSDataBase.tableName) set \(columns.componentsJoinedByString(",")) where articleId = \(article.articleId)";
        completion(sql: sql, arguments: arguments);
    }
    
    
    //TODO:查询
    internal func fetchArticles(limit:UInt){
        let sql = "SELECT * FROM \(INSDataBase.tableName) ORDER BY publicDate DESC LIMIT \(limit)";
//        let sql = "SELECT * FROM \(INSDataBase.tableName)";
        self.daQueue.inDatabase { (db:FMDatabase!) in
            let result = db.executeQuery(sql, withArgumentsInArray: []);
            while result.next(){
                NSLog("title = \(result.stringForColumn("title"))");
                print("publicDate = \(result.stringForColumn("publicDate"))");
            }
        }
    }
    internal func deleteArticle() -> Void{
        self.daQueue.inDatabase { (db:FMDatabase!) in
            
        };
    }
    
    
    
    
}
