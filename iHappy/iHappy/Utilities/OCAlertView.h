//
//  OCAlertView.h
//  Laomoney
//
//  Created by zhengda on 15/6/23.
//  Copyright (c) 2015年 zhengda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface OCAlertView : NSObject


+ (OCAlertView *)shareInstance;
- (void)presentingController:(UIViewController *)presentingController
                       title:(NSString *)title message:(NSString *)message
                buttonTitles:(NSArray *)buttonTitles
                       block:(void (^)(NSInteger))block;

- (void)alertShow;
@end
