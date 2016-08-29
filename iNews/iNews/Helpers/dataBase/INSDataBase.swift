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
                    let createSql = "create table if not exists \(INSDataBase.tableName) (articleId NOT NULL PRIMARY KEY, articleType, publicDate, title, summary, href, content, read, cacheStatus)";
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
            let totalCount = db.intForQuery("select count (articleId) from \(INSDataBase.tableName) where articleId = ?", articleModel.articleId);
            
            if totalCount > 0 {
                self.generateSQLForUpdatingArticle(articleModel, completion: { (sql:NSString, arguments:NSArray) in
                    let result = db.executeUpdate(sql as String, withArgumentsInArray: arguments as [AnyObject]);

                    if (result) {
                        NSLog("数据更新替换成功");
                    }else{
                        NSLog("数据更新替换失败");
                    }
                })
            }else{
                let insertSql = "insert into \(INSDataBase.tableName) (articleId, articleType, publicDate, title, summary, href, content, read, cacheStatus) values (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                let argumentinArray = [articleModel.articleId, articleModel.articleType, articleModel.publicDate, articleModel.title, articleModel.summary, articleModel.href, articleModel.content, articleModel.read, articleModel.cacheStatus];
                let result = db.executeUpdate(insertSql, withArgumentsInArray: argumentinArray);
                if result{
                    NSLog("数据插入成功");
                }else{
                    NSLog("数据插入失败");
                }
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
        if article.read != nil {
            columns.addObject("read = ?");
            arguments.addObject(article.read);
        }
        if article.cacheStatus != nil {
            columns.addObject("content = ?");
            arguments.addObject(article.cacheStatus);
        }
        
        let sql = "update \(INSDataBase.tableName) set \(columns.componentsJoinedByString(",")) where articleId = \(article.articleId)";
        completion(sql: sql, arguments: arguments);
    }
    
    
    //TODO:查询
    internal func fetchArticlesWithLastArticle(laseArticle:INSArticleModel?, limit:UInt) -> [INSArticleModel]{
        var sql = "";
        if laseArticle != nil {
            sql = "select * from \(INSDataBase.tableName) where publicDate <= '\(laseArticle!.publicDate)' order by publicDate desc limit \(limit)";
        }else{
            sql = "select * from \(INSDataBase.tableName) where (publicDate is not null or  publicDate != '') order by publicDate desc limit \(limit)";
        }
        var resutls = [INSArticleModel]();
        self.daQueue.inDatabase { (db:FMDatabase!) in
            let set = db.executeQuery(sql, withArgumentsInArray: []);
            while set.next(){
                let article = self.transferFMResultSetToArticle(set);
                resutls.append(article);
            }
        }
        return resutls;
    }
    
    private func transferFMResultSetToArticle(set : FMResultSet) -> INSArticleModel{
        let article = INSArticleModel();
        article.title = set.stringForColumn("title");
        article.summary = set.stringForColumn("summary");
        article.href = set.stringForColumn("href");
        article.content = set.stringForColumn("content");
        article.articleType = set.stringForColumn("articleType");
        article.articleId = set.stringForColumn("articleId");
        article.publicDate = set.stringForColumn("publicDate");
        article.read = self.numberForColumnName("read", set: set);
        article.cacheStatus = self.numberForColumnName("cacheStatus", set: set);
        return article;
    }

    func numberForColumnName(name:String, set:FMResultSet) -> NSNumber? {
        let result = set .objectForColumnName(name);
        if result.isKindOfClass(NSNull.self) {
            return nil;
        }
        return result as? NSNumber;
    }

    
    internal func deleteArticle() -> Void{
        self.daQueue.inDatabase { (db:FMDatabase!) in
            
        };
    }
    
    
    private func returnResultForQueryWithSelector(){
        
    }
    
}
