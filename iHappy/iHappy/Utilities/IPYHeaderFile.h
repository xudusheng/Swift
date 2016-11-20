//
//  IPYHeaderFile.h
//  Jurongbao
//
//  Created by wangrongchao on 15/10/17.
//  Copyright © 2015年 truly. All rights reserved.
//

#ifndef IPYHeaderFile_h
#define IPYHeaderFile_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#define kAppIdentifier [[NSBundle mainBundle]bundleIdentifier]//本应用的bundle identifier

#define IS_IPHONE_PLUS ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && [[UIScreen mainScreen] nativeScale] == 3.0f)
#define ISUPPER_IOS6 ([[UIDevice currentDevice] systemVersion].floatValue>=6.0f)
#define ISUPPER_IOS7 ([[UIDevice currentDevice] systemVersion].floatValue>=7.0f)
#define ISUPPER_IOS8 ([[UIDevice currentDevice] systemVersion].floatValue>=8.0f)
#define ISUPPER_IOS9 ([[UIDevice currentDevice] systemVersion].floatValue>=9.0f)
#define ISUPPER_IOS10 ([[UIDevice currentDevice] systemVersion].floatValue>=10.0f)

#define DEVIECE_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define DEVIECE_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


#pragma mark - 第三方库
#import "Masonry.h"
#import "JSONKit.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"//上拉下拉刷新
#import "WMPageController.h"
#import "TFHpple.h"

#import "XDSCategoryHeader.h"
#import "XDSRootModel.h"
#import "XDSHttpRequest.h"
#import "XDSUtilities.h"
#import "XDSRootControllerHeader.h"


#endif /* XDSHeaderFile_h */

