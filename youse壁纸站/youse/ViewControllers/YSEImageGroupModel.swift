//
//  YSEImageGroupModel.swift
//  youse
//
//  Created by xudosom on 16/8/27.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

import UIKit

enum YSEBOOLString : String {
    case TRUE = "true"
    case FALSE = "false"
}

class YSEImageGroupModel: NSObject {
    
    var category = "";//所属类目
    var title = "";//标题
    var db_id = "";//用于保存数据库的ID，格式：2016/0530/36107
    var item_img_url = "";//与标题一同显示的图片，格式：http://www.169bb.com/uploads/allimg/160520/1_0520135FG525.jpg
    var item_img_width = "";
    var item_img_height = "";
    var href = "";//内容图片的地址，格式：http://www.169bb.com/xingganmeinv/2016/0520/36043.html
    
    var total_page = "0";//总页数
    var total_image_count = "0";//全部图片数量
    var root_img_url = "";//子图片的根url
    var imge_type = "";//如jpg
    
    var has_get_total_page = YSEBOOLString.FALSE;//拿到总页数时设为true
    var is_ready_toshow = YSEBOOLString.FALSE;//是否已经获取到所有子图片的url，拿到图片总数时设为false
    
    
    
    override var description: String{
        return "\n" +
            "db_id = \(self.db_id)" + "\n" +
            "category = \(self.category)" + "\n" +
            "title = \(self.title)" + "\n" +
            "item_img_url = \(self.item_img_url)" + "\n" +
            "item_img_width = \(self.item_img_width)" + "\n" +
            "item_img_height = \(self.item_img_height)" + "\n" +
            "href = \(self.href)" + "\n" +
            "total_page = \(self.total_page)" + "\n" +
            "total_image_count = \(self.total_image_count)" + "\n" +
            "root_img_url = \(self.root_img_url)" + "\n" +
            "imge_type = \(self.imge_type)" + "\n" +
            "has_get_total_page = \(self.has_get_total_page)" + "\n" +
            "is_ready_toshow = \(self.is_ready_toshow)" + "\n" +
        "\n";
    }
}
