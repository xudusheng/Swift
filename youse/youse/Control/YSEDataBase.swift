//
//  YSEDataBase.swift
//  youse
//
//  Created by xudosom on 16/8/27.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

import UIKit

class YSEDataBase: NSObject {
    var daQueue : FMDatabaseQueue!;
    
    private override init() {//严格意义上的单例应该将init()方法设为私有
        let docPath = UIApplication.cw_documentsPath();
        let dbPath = docPath.stringByAppendingString("/image_group.db");
        print("dbPath = \(dbPath)");
        
        var filemanager = NSFileManager.defaultManager().fileExistsAtPath(dbPath);
        NSLog("\(filemanager)");
        self.daQueue = FMDatabaseQueue(path: dbPath);
        filemanager = NSFileManager.defaultManager().fileExistsAtPath(dbPath);
        NSLog("\(filemanager)");
        
        if self.daQueue != nil {
            
            self.daQueue.inDatabase({ (db:FMDatabase!) in
                //创建表
                if !db.tableExists(DB_TABLENAME){
                    let createSql = "create table if not exists \(DB_TABLENAME) (db_id not null primary key, category, title, item_img_url, item_img_width, item_img_height, href, total_page, total_image_count, root_img_url, imge_type, has_get_total_page, is_ready_toshow)";
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
    
    //第二种单例写法（struct + dispatch_once）
    struct StaticInstance {
        static var onceToken : dispatch_once_t = 0;
        static var instance : YSEDataBase? = nil;
    }
    static internal func shareInstance() -> YSEDataBase{
        dispatch_once(&StaticInstance.onceToken) {
            StaticInstance.instance = YSEDataBase();
        };
        return StaticInstance.instance!;
    }
    
    
    //TODO:插入或者更新一条数据
    internal func storeOrUpdate(imageGroupModel model:YSEImageGroupModel!) ->YSEImageGroupModel{
        var updateSuccess = false;
        self.daQueue.inDatabase { (db:FMDatabase!) in
            let totalCount = db.intForQuery("select count (db_id) from \(DB_TABLENAME) where db_id = ?", model.db_id);
            if totalCount > 0 {
                self.generateSQLForUpdating(imageGroupModel: model, completion: { (sql, arguments) in
                    let result = db.executeUpdate(sql as String, withArgumentsInArray: arguments as [AnyObject]);
                    
                    if (result) {
                        NSLog("数据更新替换成功");
                        updateSuccess = true;
                    }else{
                        NSLog("数据更新替换失败");
                    }
                })
            }else{
                let insertSql = "insert into \(DB_TABLENAME) (db_id, category, title, item_img_url, item_img_width, item_img_height, href, total_page, total_image_count, root_img_url, imge_type, has_get_total_page, is_ready_toshow) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                let argumentinArray = [
                    model.db_id,
                    model.category,
                    model.title,
                    model.item_img_url,
                    model.item_img_width,
                    model.item_img_height,
                    model.href,
                    model.total_page,
                    model.total_image_count,
                    model.root_img_url,
                    model.imge_type,
                    model.has_get_total_page.rawValue,
                    model.is_ready_toshow.rawValue];
                let result = db.executeUpdate(insertSql, withArgumentsInArray: argumentinArray);
                if result{
                    NSLog("数据插入成功");
                }else{
                    NSLog("数据插入失败");
                }
            }
        };
        
        var newModel = model;
        if updateSuccess {
            let fetchModel = self.fetchImageGroupModelFromDataBase(imageGroupModel: newModel);
            if fetchModel != nil{
                newModel = fetchModel;
            }
        }
        return newModel;
    }
    
    
    private func fetchImageGroupModelFromDataBase(imageGroupModel model:YSEImageGroupModel!) -> YSEImageGroupModel? {
        var fetchModel = model;
        let sql = "select * from \(DB_TABLENAME) where db_id = '\(fetchModel.db_id)'";
        self.daQueue.inDatabase { (db:FMDatabase!) in
            let set = db.executeQuery(sql, withArgumentsInArray: []);
            while set.next(){
                let transferModel = self.transferFMResultSetToImageGroupModel(set);
                fetchModel = transferModel;
                break;
            }
            set.close();
        };
        return fetchModel;
    }
    
    private func generateSQLForUpdating(imageGroupModel model:YSEImageGroupModel!, completion:(sql:String, arguments:[String]) -> ()){
        var columns = [String]();
        var arguments = [String]();
        
        columns.append("db_id = ?");
        arguments.append(model.db_id);
        
        if model.category.characters.count > 0 {
            columns.append("category = ?");
            arguments.append(model.category);
        }
        if model.title.characters.count > 0 {
            columns.append("title = ?");
            arguments.append(model.title);
        }
        if model.item_img_url.characters.count > 0 {
            columns.append("item_img_url = ?");
            arguments.append(model.item_img_url);
        }

        if Float(model.item_img_width) > 0 {
            columns.append("item_img_width = ?");
            arguments.append(model.item_img_width);
        }
        if Float(model.item_img_height) > 1 {
            columns.append("item_img_height = ?");
            arguments.append(model.item_img_height);
        }
        if model.href.characters.count > 0 {
            columns.append("href = ?");
            arguments.append(model.href);
        }
        
        if model.root_img_url.characters.count > 0 {
            columns.append("root_img_url = ?");
            arguments.append(model.root_img_url);
        }
        if model.imge_type.characters.count > 0 {
            columns.append("imge_type = ?");
            arguments.append(model.imge_type);
        }
        
        if Int(model.total_page) > 0 {
            columns.append("total_page = ?");
            arguments.append(model.total_page);
        }
        if Int(model.total_image_count) > 0 {
            columns.append("total_image_count = ?");
            arguments.append(model.total_image_count);
        }
        if model.has_get_total_page == YSEBOOLString.TRUE {
            columns.append("has_get_total_page = ?");
            arguments.append(model.has_get_total_page.rawValue);
        }
        if model.is_ready_toshow == YSEBOOLString.TRUE {
            columns.append("is_ready_toshow = ?");
            arguments.append(model.is_ready_toshow.rawValue);
        }

        let columns_NSArray = columns as NSArray;
        let sql = "update \(DB_TABLENAME) set \(columns_NSArray.componentsJoinedByString(", ")) where db_id = '\(model.db_id)'";
        completion(sql: sql, arguments: arguments);
    }
    
    
    
    private func transferFMResultSetToImageGroupModel(set : FMResultSet) -> YSEImageGroupModel{
        let model = YSEImageGroupModel();
        model.category = set.stringForColumn("category");
        model.title = set.stringForColumn("title");
        model.db_id = set.stringForColumn("db_id");
        model.item_img_url = set.stringForColumn("item_img_url");
        model.item_img_width = set.stringForColumn("item_img_width");
        model.item_img_height = set.stringForColumn("item_img_height");
        model.href = set.stringForColumn("href");
        model.total_page = set.stringForColumn("total_page");
        model.total_image_count = set.stringForColumn("total_image_count");
        model.root_img_url = set.stringForColumn("root_img_url");
        model.imge_type = set.stringForColumn("imge_type");
        
        let has_get_total_page = set.stringForColumn("has_get_total_page");
        let is_ready_toshow = set.stringForColumn("is_ready_toshow");
        model.has_get_total_page = (has_get_total_page == YSEBOOLString.FALSE.rawValue) ? YSEBOOLString.FALSE : YSEBOOLString.TRUE;
        model.is_ready_toshow = (is_ready_toshow == YSEBOOLString.FALSE.rawValue) ? YSEBOOLString.FALSE : YSEBOOLString.TRUE;

        return model;
    }
    
}
