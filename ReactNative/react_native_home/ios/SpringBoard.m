//
//  SpringBoard.m
//  react_native_home
//
//  Created by xudosom on 2016/10/23.
//  Copyright © 2016年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "SpringBoard.h"
#import "XDSInMobiAdView.h"

@implementation SpringBoard
RCT_EXPORT_MODULE();
//RCT_EXPORT_METHOD(Login:(NSString *)name password:(NSString *)password){
//  NSLog(@"%@, %@", name, password);
//}

RCT_EXPORT_METHOD(Login:(NSString *)name){

}

RCT_EXPORT_METHOD(addAdView){
  CGFloat width = [UIScreen mainScreen].bounds.size.width;
  XDSInMobiAdView * adView = [[XDSInMobiAdView alloc]initWithFrame:CGRectMake(0, 20, width, 50)];
  NSLog(@"adView = %@", adView);
}

@end
