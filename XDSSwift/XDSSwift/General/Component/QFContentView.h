//
//  QFContentView.h
//  ScrollViewDemo
//
//  Created by Gome on 14-7-26.
//  Copyright (c) 2014年 xude. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QFScrollView.h"
@interface QFContentView : UIView<QFScrollViewDelegate>{
    NSInteger _curIndex;
}

@end
