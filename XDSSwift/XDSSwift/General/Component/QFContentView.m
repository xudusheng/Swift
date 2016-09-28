//
//  QFContentView.m
//  ScrollViewDemo
//
//  Created by Gome on 14-7-26.
//  Copyright (c) 2014年 xude. All rights reserved.
//

#import "QFContentView.h"

@implementation QFContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//清除旧数据
-(void)clearData{
    
}
//刷新指定页内容
-(void)updateData:(NSInteger)indexPage data:(id)dataObject{
    NSArray * views = [self subviews];
    for (UIView * view in views) {
        [view removeFromSuperview];
    }
    [self addSubview:dataObject];
}

//设置新页码
-(void)setPageIndex:(NSInteger)indexPage{
    _curIndex=indexPage;
}

//获得当前对象的页码
-(NSInteger)getPageIndex{
    return _curIndex;
}


@end
