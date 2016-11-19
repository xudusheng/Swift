//
//  OCAlertView.m
//  Laomoney
//
//  Created by zhengda on 15/6/23.
//  Copyright (c) 2015年 zhengda. All rights reserved.
//

#import "OCAlertView.h"
@interface OCAlertView()<UIAlertViewDelegate>

@property (strong, nonatomic)UIViewController * presentingController;
@property (strong, nonatomic)NSString * title;
@property (strong, nonatomic)NSString * message;
@property (strong, nonatomic)NSArray * buttonTitles;
@property (copy, nonatomic) void (^block)(NSInteger);

@end

@implementation OCAlertView
#pragma mark UIAlertView，iOS8以后使用UIAlertController
+ (OCAlertView *)shareInstance{
    static OCAlertView * alert = nil;
    if (alert == nil) {
        alert = [[OCAlertView alloc]init];
    }
    return alert;
}

- (void)presentingController:(UIViewController *)presentingController title:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles block:(void (^)(NSInteger))block{
    self.presentingController = nil;
    self.title = nil;
    self.message = nil;
    self.buttonTitles = nil;
    self.block = nil;
    
    self.presentingController = presentingController;
    self.title = title;
    self.message = message;
    self.buttonTitles = buttonTitles;
    self.block = block;
}

- (void)alertShow{
    [self alertViewWithPresentingController:self.presentingController title:self.title message:self.message buttonTitles:self.buttonTitles];
}

- (void)alertViewWithPresentingController:(UIViewController *)presentingController title:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles{
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        for (int i = 0; i < buttonTitles.count; i ++) {
            [alertController addAction:[UIAlertAction actionWithTitle:buttonTitles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                self.block(i);
            }]];
        }
        [presentingController presentViewController:alertController animated:YES completion:nil];
}

@end
