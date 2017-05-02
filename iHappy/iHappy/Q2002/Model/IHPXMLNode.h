//
//  IHPXMLNode.h
//  iHappy
//
//  Created by dusheng.xu on 2017/4/29.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface IHPXMLNode : JSONModel
@property (copy, nonatomic) NSString *xPathString;
@property (copy, nonatomic) NSString *childNodeName;
@property (copy, nonatomic) NSString *className;


@end
