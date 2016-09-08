//
//  OCRuntimeModel+Associated.m
//  XDSSwift
//
//  Created by zhengda on 16/9/8.
//  Copyright © 2016年 zhengda. All rights reserved.
//

#import "OCRuntimeModel+Associated.h"
#import <objc/runtime.h>
#import <objc/message.h>
@implementation OCRuntimeModel (Associated)
char * associatedBustKey = "associatedBust";
char * associatedCallBackKey = "associatedCallBack";

- (void)setAssociatedBust:(NSNumber *)associatedBust{
    objc_setAssociatedObject(self, associatedBustKey, associatedBust, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber *)associatedBust{
    return objc_getAssociatedObject(self, associatedBustKey);
}

- (void)setAssociatedCallBack:(CodingCallBack)associatedCallBack{
    objc_setAssociatedObject(self, associatedCallBackKey, associatedCallBack, OBJC_ASSOCIATION_COPY_NONATOMIC);

}

- (CodingCallBack)associatedCallBack{
    return objc_getAssociatedObject(self, associatedCallBackKey);
}


@end
