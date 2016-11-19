//
//  OCControlAlertView.h
//  Laomoney
//
//  Created by zhengda on 15/7/6.
//  Copyright (c) 2015年 zhengda. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^controlAlertViewBlock)(NSInteger tag);
@interface OCControlAlertView : UIView<UITextFieldDelegate>

@property (nonatomic, strong)void(^controlAlertViewBlock)(NSInteger tag);
@property (strong, nonatomic)UITextField * inputTextField;


- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles;
- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder buttonTitles:(NSArray *)buttonTitles;//带输入框

@end
