//
//  YSEGlobalDefinitions.h
//  youse
//
//  Created by xudosom on 16/8/27.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

/**
 用于设置全局宏
 */
#ifndef YSEGlobalDefinitions_h
#define YSEGlobalDefinitions_h

#define IOS6 ([[UIDevice currentDevice] systemVersion].floatValue>=6.0f)
#define IOS7 ([[UIDevice currentDevice] systemVersion].floatValue>=7.0f)
#define IOS8 ([[UIDevice currentDevice] systemVersion].floatValue>=8.0f)
#define DEVICE_APP_BUNDLE_IDENTIFIER  [[NSBundle mainBundle]bundleIdentifier]//本应用的bundle identifier

#define DEVICE_SCREEN_WIDTH               [UIScreen mainScreen].bounds.size.width
#define DEVICE_SCREEN_HEIGHT              [UIScreen mainScreen].bounds.size.height
#define DEVICE_SCREEN_BOUNDS               [UIScreen mainScreen].bounds


#ifdef DEBUG
# define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...) {}
#endif

/**
 *  单例宏
        \ 代表下一行也属于宏
        ## 是分隔符
 */

#define OCT_SYNTHESIZE_SINGLETON_FOR_CLASS(__class_name__) \
static __class_name__ *_instance; \
\
+ (__class_name__ *)shared##__class_name__ \
{ \
if (_instance == nil) { \
_instance = [[self alloc] init]; \
} \
return _instance; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
}


#endif /* OCTGlobalDefinitions_h */
