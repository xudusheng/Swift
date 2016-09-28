//
//  DHFScrollView.h
//  iMagazine
//
//  Created by DuHaiFeng on 13-10-27.
//  Copyright (c) 2013年 dhf. All rights reserved.
//
#import <UIKit/UIKit.h>

//子页对象必须遵守的协议
@protocol QFScrollViewDelegate <NSObject>

//清除旧数据
-(void)clearData;
//刷新指定页内容
-(void)updateData:(NSInteger)indexPage data:(id)dataObject;
//设置新页码
-(void)setPageIndex:(NSInteger)indexPage;
//获得当前对象的页码
-(NSInteger)getPageIndex;

@end

//滚动视图所在对象必须遵守的协议
@protocol  QFScrolViewDataDelegate<NSObject>
//返回总页码
-(NSInteger)numberOfPages;
//获得指定页的位置和大小
-(CGSize)perPageSize;
//获得指定页实例
-(id<QFScrollViewDelegate>)pageForIndex:(NSInteger)index;
//返回要显示的数据对象
-(id)dataObjectForIndex:(NSInteger)index;
//跳转到指定页
-(void)pageChange:(NSInteger)pageNumber animated:(BOOL)animated;

@end

@interface QFScrollView : UIScrollView<UIScrollViewDelegate>
{
    @private
    //回收集合
    NSMutableSet *recycledPages;
    //可见集合
    NSMutableSet *visiblePages;
    //总页码
	NSInteger pageCount;
    //当前页码
    NSInteger curPage;
    BOOL userScroll;
    
}
//@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) id<QFScrolViewDataDelegate> delegateEx;

-(id)initWithFrame:(CGRect)frame count:(NSInteger)count;
//移除所有子页
-(void)removeAllPage;
//载入可见页内容
- (void)tilePages;
//切换到指定页码
-(void)changePage:(int)page animated:(BOOL)animated;

@end
