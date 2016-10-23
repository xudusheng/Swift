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

@implementation SpringBoard
RCT_EXPORT_MODULE();
//RCT_EXPORT_METHOD(Login:(NSString *)name password:(NSString *)password){
//  NSLog(@"%@, %@", name, password);
//}

RCT_EXPORT_METHOD(Login:(NSString *)name)
{
  UIViewController *controller = (UINavigationController*)[[[UIApplication sharedApplication] keyWindow] rootViewController];
  UIViewController *loginVC = [[UIViewController alloc] init];
  loginVC.view.backgroundColor = name.length? [UIColor redColor]:[UIColor yellowColor];
  [controller presentViewController:loginVC animated:YES completion:nil];
}

@end
