//
//  OCRuntimeModel.m
//  XDSSwift
//
//  Created by zhengda on 16/9/7.
//  Copyright © 2016年 zhengda. All rights reserved.
//

#import "OCRuntimeModel.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface OCRuntimeModel()
{
    NSString *_occupationPro;
    NSString *_nationalityPro;
}
@end
@implementation OCRuntimeModel
////第一步：通过resolveInstanceMethod：方法决定是否动态添加方法。如果返回Yes则通过class_addMethod动态添加方法，消息得到处理，结束；如果返回No，则进入下一步；
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    if ([NSStringFromSelector(sel) isEqualToString:@"sing"]) {
        class_addMethod(self, sel, (IMP)otherSimg, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
//
////第二步：这步会进入forwardingTargetForSelector:方法，用于指定备选对象响应这个selector，不能指定为self。如果返回某个对象则会调用对象的方法，结束。如果返回nil，则进入第三部；
//- (id)forwardingTargetForSelector:(SEL)aSelector{
//    return nil;
//}
//
////第三部：这步我们要通过methodSignatureForSelector:方法签名，如果返回nil，则消息无法处理。如果返回methodSignature，则进入下一步；
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
//    return nil;
//}
//
////第四部：这步调用forwardInvocation：方法，我们可以通过anInvocation对象做很多处理，比如修改实现方法，修改响应对象等，如果方法调用成功，则结束。如果失败，则进入doesNotRecognizeSelector方法，若我们没有实现这个方法，那么就会crash。
//- (void)forwardInvocation:(NSInvocation *)anInvocation{
//    
//}
//- (void)doesNotRecognizeSelector:(SEL)aSelector{
//    
//}


- (NSDictionary *)allProperties{
    unsigned int count = 0;
    objc_property_t * properties = class_copyPropertyList(self.class, &count);
    NSMutableDictionary *resultDict = [@{} mutableCopy];
    for (NSUInteger i = 0; i < count; i ++) {
        const char * propertyName = property_getName(properties[i]);
        NSString * name = [NSString stringWithUTF8String:propertyName];
        id propertyValue = [self valueForKey:name];
        if (propertyValue) {
            resultDict[name] = propertyValue;
        }else{
            resultDict[name] = @"字典的key对于的value不能为nil";
        }
    }
    free(properties);
    return resultDict;
}
- (NSDictionary *)allIvars{
    unsigned int count = 0;
    Ivar * ivars = class_copyIvarList(self.class, &count);
    NSMutableDictionary *resultDict = [@{} mutableCopy];
    for (NSUInteger i = 0; i < count; i ++) {
        const char * ivarName = ivar_getName(ivars[i]);
        NSString * name = [NSString stringWithUTF8String:ivarName];
        id ivarValue = [self valueForKey:name];
        if (ivarValue) {
            resultDict[name] = ivarValue;
        }else{
            resultDict[name] = @"字典的key对于的value不能为nil";
        }
        
        const char * typeChar = ivar_getTypeEncoding(ivars[i]);
        NSString * type = [NSString stringWithUTF8String:typeChar];
        resultDict[@"type"] = type;
        
    }
    
    free(ivars);
    return resultDict;
}
- (NSDictionary *)allMethods{
    unsigned int count = 0;
    Method * methods = class_copyMethodList(self.class, &count);
    NSMutableDictionary *resultDict = [@{} mutableCopy];
    for (NSUInteger i = 0; i < count; i ++) {
        Method m = methods[i];
        SEL methodSEL = method_getName(m);
        const char * methodName = sel_getName(methodSEL);
        NSString * name = [NSString stringWithUTF8String:methodName];
        char type[256] = {};
        method_getReturnType(m, type, sizeof(type));
        resultDict[name] = [NSString stringWithUTF8String:type];
    }
    free(methods);
    return resultDict;
}

void otherSimg(id obj, SEL _cmd){
    [SwiftUtil showSingleAlertView:nil
                           message:@"没有sing方法，动态添加了sing方法"];
}

@end
