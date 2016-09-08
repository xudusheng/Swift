//
//  OCRuntimeModel+Associated.h
//  XDSSwift
//
//  Created by zhengda on 16/9/8.
//  Copyright © 2016年 zhengda. All rights reserved.
//

#import "OCRuntimeModel.h"
typedef void (^CodingCallBack)();

@interface OCRuntimeModel (Associated)

@property (nonatomic, strong) NSNumber *associatedBust; // 胸围
@property (nonatomic, copy) CodingCallBack associatedCallBack;  // 写代码

@end
