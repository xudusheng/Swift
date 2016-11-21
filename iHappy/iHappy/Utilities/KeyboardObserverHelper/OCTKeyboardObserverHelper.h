//
//  OCTKeyboardObserverHelper.h
//  Laomoney
//
//  Created by zhengda on 16/7/8.
//  Copyright © 2016年 zhengda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCTKeyboardObserverHelper : NSObject
/**
 *  键盘监听器
 *
 *  @param toMovedView 键盘遮挡时需要移动的View
 */
+ (void)addKeyboardObserverWithToMovedView:(UIView * _Nonnull)toMovedView;
+ (void)removeKeyboardObserver;
@end
