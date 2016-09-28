//
//  DHFScrollView.m
//  iMagazine
//
//  Created by DuHaiFeng on 13-10-27.
//  Copyright (c) 2013年 dhf. All rights reserved.
//

#import "QFScrollView.h"

@interface  QFScrollView()

@property (nonatomic,assign) CGSize pageSize;

@end

@implementation QFScrollView

@synthesize delegateEx=_delegateEx;


-(id)initWithFrame:(CGRect)frame count:(NSInteger)count
{
    self = [super initWithFrame:frame];
    if (self) {
        //UIScrollViewDelegate设置成自身
        self.delegate=self;
        pageCount=count;
        
        //实例化两个集合
        recycledPages = [[NSMutableSet alloc] init];
        visiblePages  = [[NSMutableSet alloc] init];
        
        userScroll=YES;
        
        //注册旋转消息
        [self registerRotation:@selector(updateLayout)];
    }
    return self;
}
- (void)dealloc
{
    //删除旋转消息
    [self removeRotation];
}
//注册旋转通知
-(void)registerRotation:(SEL)method{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:method
												 name:UIDeviceOrientationDidChangeNotification object:nil];
}
-(void)removeRotation
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}
//删除所有子视图 (这里是UIImageView)
-(void)removeAllSubviews:(UIView*)view
{
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            [subview removeFromSuperview];
        }
    }
    
}
//屏幕旋转后重新布局
-(void)updateLayout
{
    //如果转屏，根据实际情况是否重新计算总页码
    [self removeAllPage];
 
//*********************屏幕旋转适配**********************
    //获得设备方向
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    //获得屏幕大小
    CGRect screenBounds=[UIScreen mainScreen].bounds;
    //NSLog(@"bounds:%@",NSStringFromCGRect(screenBounds));
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
        screenBounds=CGRectMake(0, 0, 568, 320);
    }
    else{
        screenBounds=CGRectMake(0, 0, 320, 568);
    }
//    重新设置位置和大小
    self.frame=screenBounds;
//*********************屏幕旋转适配**********************

    //设置内容区的大小
    self.contentSize=CGSizeMake(pageCount*screenBounds.size.width, screenBounds.size.height);
    //切换到转屏前的页码
    [self changePage:(int)curPage animated:NO];
    //加载当前可见页
    [self tilePages];
}
//删除所有子页信息
-(void)removeAllPage
{
    [recycledPages removeAllObjects];
    [visiblePages removeAllObjects];
    [self removeAllSubviews:self];
}
//从每一页对象获得它的视图,目前支持两种页对象(UIViewController的实例或UIView的实例)
-(UIView<QFScrollViewDelegate>*)viewFromPage:(id<QFScrollViewDelegate>)pageInstance
{
    if ([pageInstance isKindOfClass:[UIView class]]) {
        return (UIView<QFScrollViewDelegate>*)pageInstance;
    }
    else if([pageInstance isKindOfClass:[UIViewController class]]){
        UIViewController *controller=(UIViewController*)pageInstance;
        return (UIView<QFScrollViewDelegate>*)(controller.view);
    }
//    NSLog(@"暂没有支持类型");
    return (UIView<QFScrollViewDelegate>*)pageInstance;
}
//加载屏幕可见页(包含预加载页,用户体验考虑)
- (void)tilePages{
    //获得总页码
    pageCount=[self.delegateEx numberOfPages];
    //从委拖对象获得每一页大小
    self.pageSize=[self.delegateEx perPageSize];
	//计算可见页码
    CGRect visibleBounds = self.bounds;
    //self.contentOffset
    //NSLog(@"cur:%@",NSStringFromCGRect(visibleBounds));
    //跟据左下角x和右上角x计算当前可见页码
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / self.pageSize.width);
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / self.pageSize.width);
    //保存当前页码
    curPage=firstNeededPageIndex;
    //预加载当前页的前后页
    firstNeededPageIndex = MAX(firstNeededPageIndex-1, 0);
    lastNeededPageIndex  = (int)MIN(lastNeededPageIndex+1, pageCount- 1);
    // 收藏不再可见页,以备复用
    for (id<QFScrollViewDelegate> page in visiblePages) {
        //如果当前页不再是可见页,将它回收
        if ([page getPageIndex] < firstNeededPageIndex || [page getPageIndex] > lastNeededPageIndex) {
            //清除旧数据,回收复用
            [page clearData];
            [recycledPages addObject:page];
            //从屏幕上将它移除
            UIView<QFScrollViewDelegate> *view=[self viewFromPage:page];
            [view removeFromSuperview];
            
        }
    }
    //从可见集合中去掉回收集合包含的内容
    [visiblePages minusSet:recycledPages];
    // 添加新可见页
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        //不是可见页再处理，否则不处理
        if (![self isDisplayingPageForIndex:index]) {
            //是否存在可复用的实例
            id<QFScrollViewDelegate> page = [self dequeueRecycledPage];
            //不存在就创建
            if (page == nil) {
                //从委拖对象获得某页对象
				page = [self.delegateEx pageForIndex:index];
			}
            
            //设置新的页码
			[page setPageIndex:index];
            
			//设置新的位置
			CGRect frame = CGRectMake(self.pageSize.width*index, 0, self.pageSize.width,self.pageSize.height);
            UIView <QFScrollViewDelegate> *view=[self viewFromPage:page];
			view.frame  = frame;
            //将当前页的视图添加到滚动视图上(自己上)
            [self addSubview:view];
            //更新内容
            [self configurePage:page forIndex:index];
            //加入可见集合
            [visiblePages addObject:page];
			
        }
    }
}
//指定的页码是否是可见页
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index{
    BOOL foundPage = NO;
    for (id<QFScrollViewDelegate> page in visiblePages) {
        if ([page getPageIndex] == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}
//是否有可复用的页实例
- (id<QFScrollViewDelegate>)dequeueRecycledPage{
    //获得回收集中的任意对象
    id<QFScrollViewDelegate> page = [recycledPages anyObject];
    if (page) {
        //从回收集合移除
        [recycledPages removeObject:page];
    }
    //返回复用对象
    return page;
}
//更新某页内容(复用的对象或者新创建的对象)
- (void)configurePage:(id<QFScrollViewDelegate>)page forIndex:(NSUInteger)index
{
    //从委拖对象获得数据
    id dataObject=[self.delegateEx dataObjectForIndex:index];
    //更新这一页的数据
    [page updateData:index data:dataObject];
}
//跳转到指定页
-(void)changePage:(int)pageIndex animated:(BOOL)animated{
    //页码非法
	if (pageIndex<0||pageIndex>=pageCount) {
		return;
	}
    //获得每一页的大小
    self.pageSize=[self.delegateEx perPageSize];
    //计算要跳转到的位置
   CGRect frame = CGRectMake(self.pageSize.width*pageIndex, 0, self.pageSize.width,self.pageSize.height);
    //设置用户滚动为NO
	userScroll=NO;
    //滚动到指定位置
    [self scrollRectToVisible:frame animated:animated];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //设置用户滚动为YES
    userScroll=YES;
}

//滚动视图发生滚动的协议方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tilePages];
    //如果是用户滚动,通知委拖对象处理滚动事件
    if (userScroll) {
        [self.delegateEx pageChange:curPage animated:YES];
    }
}


@end
