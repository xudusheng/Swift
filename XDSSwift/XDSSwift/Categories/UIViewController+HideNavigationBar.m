//
//  UIViewController+HideNavigationBar.m
//  XDSSwift
//
//  Created by zhengda on 16/9/9.
//  Copyright © 2016年 zhengda. All rights reserved.
//

#import "UIViewController+HideNavigationBar.h"
@interface XDSViewControllerHooker : NSObject
@end
@implementation XDSViewControllerHooker
static XDSViewControllerHooker * hooker;
+ (XDSViewControllerHooker *)shareInstance{
    if (hooker == nil) {
        hooker = [[self alloc]init];
    }
    return hooker;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hooker = [super allocWithZone:zone];
    });
    return hooker;
}


+ (void)load{
    [XDSViewControllerHooker shareInstance];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configHooker];
    }
    return self;
}

- (void)configHooker{
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:)
                              withOptions:AspectPositionAfter
                               usingBlock:^(id<AspectInfo> info){
                                   UIViewController * vc = [info instance];
                                   [vc.navigationController setNavigationBarHidden:vc.hidesTopBarWhenPushed
                                                                          animated:YES];
                               }error:nil];
}
@end

@implementation UIViewController (HideNavigationBar)

//void MethodSwizzle(Class aClass, SEL orig_sel, SEL alt_sel) {
//    Method orig_method = nil, alt_method = nil;
//    orig_method = class_getInstanceMethod(aClass, orig_sel);
//    alt_method = class_getInstanceMethod(aClass, alt_sel);
//    if ((orig_method != nil) && (alt_method != nil))
//    {
//        IMP originIMP = method_getImplementation(orig_method);
//        IMP altIMP = method_setImplementation(alt_method, originIMP);
//        method_setImplementation(orig_method, altIMP);
////        class_replaceMethod(aClass, <#SEL name#>, <#IMP imp#>, <#const char *types#>)
//    }
//}
//
//+ (void)load{
//    MethodSwizzle([self class], @selector(viewWillAppear:), @selector(myViewWillAppear:));
//}
//
//- (void)myViewWillAppear:(BOOL)animated{
//    NSLog(@"======%s", __func__);
//}

- (void)swizzleMethod:(SEL)origSelector withMethod:(SEL)newSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, origSelector);
    Method swizzledMethod = class_getInstanceMethod(class, newSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        origSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


char * hidesTopBarWhenPushedKey = "hidesTopBarWhenPushed";
- (void)setHidesTopBarWhenPushed:(BOOL)hidesTopBarWhenPushed{
    objc_setAssociatedObject(self, hidesTopBarWhenPushedKey, @(hidesTopBarWhenPushed), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hidesTopBarWhenPushed{
    id hidesTopBarWhenPushed = objc_getAssociatedObject(self, hidesTopBarWhenPushedKey);
    return [hidesTopBarWhenPushed boolValue];
}

@end
