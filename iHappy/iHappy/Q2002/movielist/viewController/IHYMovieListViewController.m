//
//  IHYMovieListViewController.m
//  iHappy
//
//  Created by xudosom on 2016/11/19.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import "IHYMovieListViewController.h"
#import "IHYMovieModel.h"
#import "IHPMovieCell.h"

#import "IHYMovieDetailViewController.h"
#import "IHPPlayerViewController.h"
@interface IHYMovieListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) NSMutableArray<IHYMovieModel *> * movieList;
@property (strong, nonatomic) UICollectionView * movieCollectionView;
@property (copy, nonatomic) NSString * nextPageUrl;

@end

@implementation IHYMovieListViewController

NSString * const MovieListViewController_movieCellIdentifier = @"IHPMovieCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self movieListViewControllerDataInit];
    [self createMovieListViewControllerUI];
}


#pragma mark - UI相关
- (void)createMovieListViewControllerUI{
    self.view.backgroundColor = [UIColor whiteColor];
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小
    CGFloat itemMargin = 10;
    CGFloat width = (DEVIECE_SCREEN_WIDTH - itemMargin * 4)/3;
    layout.itemSize = CGSizeMake(width, width*4/3);
    //创建collectionView 通过一个布局策略layout来创建
    self.movieCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _movieCollectionView.backgroundColor = [UIColor whiteColor];
    //代理设置
    _movieCollectionView.delegate=self;
    _movieCollectionView.dataSource=self;
    //注册item类型 这里使用系统的类型
    [self.view addSubview:_movieCollectionView];
    
    [_movieCollectionView registerNib:[UINib nibWithNibName:@"IHPMovieCell" bundle:nil] forCellWithReuseIdentifier:MovieListViewController_movieCellIdentifier];
    [_movieCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    _movieCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(fetchMovieListTop)];
    _movieCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [_movieCollectionView.mj_header beginRefreshing];
    
}

#pragma mark - 网络请求
- (void)fetchMovieListTop{
    [self fetchMovieList:YES];
    [_movieCollectionView.mj_footer resetNoMoreData];
}
- (void)loadMoreData{
    if (_nextPageUrl.length) {
        [self fetchMovieList:NO];
    }
}
#pragma mark - 代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _movieList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IHPMovieCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:MovieListViewController_movieCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    IHYMovieModel * movieModel = _movieList[indexPath.row];
    [cell cellWithMovieModel:movieModel];
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    IHYMovieModel * movieModel = _movieList[indexPath.row];
//    IHYMovieDetailViewController * movieDetailVC = [[IHYMovieDetailViewController alloc] init];
//    movieDetailVC.movieModel = movieModel;
//    [self.navigationController pushViewController:movieDetailVC animated:YES];
    
    IHYMovieModel * movieModel = _movieList[indexPath.row];
    IHPPlayerViewController * movieDetailVC = [[IHPPlayerViewController alloc] init];
    movieDetailVC.movieModel = movieModel;
    [self.navigationController pushViewController:movieDetailVC animated:YES];
    
    
}
#pragma mark - 点击事件处理
- (void)fetchMovieList:(BOOL)isTop{
    __weak typeof(self)weakSelf = self;
    [[[XDSHttpRequest alloc] init] htmlRequestWithHref:isTop?_firstPageUrl:_nextPageUrl
                                         hudController:self
                                               showHUD:NO
                                               HUDText:nil
                                         showFailedHUD:YES
                                               success:^(BOOL success, NSData * htmlData) {
                                                   if (success) {
                                                       [weakSelf detailHtmlData:htmlData needClearOldData:isTop];
                                                   }else{
                                                       [XDSUtilities showHud:@"数据请求失败，请稍后重试" rootView:self.navigationController.view hideAfter:1.2];
                                                   }
                                                   [weakSelf endRefresh];
                                               } failed:^(NSString *errorDescription) {
                                                   [weakSelf endRefresh];
                                               }];
}

#pragma mark - 其他私有方法

- (void)endRefresh{
    [_movieCollectionView.mj_header endRefreshing];
    [_movieCollectionView.mj_footer endRefreshing];
    if (!self.nextPageUrl.length) {
        [_movieCollectionView.mj_footer endRefreshingWithNoMoreData];
    }else {
        [_movieCollectionView.mj_footer resetNoMoreData];
    }
}
- (void)detailHtmlData:(NSData *)htmlData needClearOldData:(BOOL)needClearOldData{
    TFHpple * hpp = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    NSArray * pageElements = [hpp searchWithXPathQuery:@"//div[@class =\"pages\"]//ul"];
    
    if (pageElements.count > 0) {
        TFHppleElement * pageElement = pageElements.firstObject;
        NSArray * childElements = [pageElement childrenWithTagName:@"li"];
        self.nextPageUrl = nil;
        for (int i = 0; i < childElements.count; i ++) {
            TFHppleElement * li_element = childElements[i];
            NSString * className = [li_element objectForKey:@"class"];
            if ([className isEqualToString:@"on"] && i + 1 < childElements.count) {
                TFHppleElement * nextPage_element = childElements[i+1];
                NSString * nextHref =  [[nextPage_element firstChildWithTagName:@"a"] objectForKey:@"href"];
                self.nextPageUrl =nextHref;
                break;
            }
        }
    }else{
        self.nextPageUrl = nil;
    }
    
    
    NSArray * rowElements = [hpp searchWithXPathQuery:@"//li[@class=\"p1 m1\"]"];
    NSMutableArray * newMovies = [NSMutableArray arrayWithCapacity:0];
    for (TFHppleElement * oneElements in rowElements) {
        TFHppleElement * a_link_hover =  [oneElements firstChildWithClassName:@"link-hover"];//跳转地址
        TFHppleElement * image_lazy =  [a_link_hover firstChildWithClassName:@"lazy"];//图片
        
        TFHppleElement * span_lzbz =  [a_link_hover firstChildWithClassName:@"lzbz"];
        TFHppleElement * p_name = [span_lzbz firstChildWithClassName:@"name"];//名称
        TFHppleElement * p_actor =  [span_lzbz childrenWithClassName:@"actor"].lastObject;//更新时间
        
        TFHppleElement * p_other =  [a_link_hover firstChildWithClassName:@"other"];//其他描述
        
        NSString * name = p_name.text;
        NSString * href = [a_link_hover objectForKey:@"href"];
        NSString * imageurl = [image_lazy objectForKey:@"src"];
        NSString * update = p_actor.text;
        NSString * other = p_other.text;
        
        IHYMovieModel * model = [[IHYMovieModel alloc] init];
        model.name = name;
        model.href = href;
        model.imageurl = imageurl;
        model.update = update;
        model.other = other;
        [newMovies addObject:model];
    }
    if (newMovies.count > 0) {
        if (needClearOldData) {
            [_movieList removeAllObjects];
        }
        [_movieList addObjectsFromArray:newMovies];
        [_movieCollectionView reloadData];
    }else{
        [_movieCollectionView.mj_footer endRefreshingWithNoMoreData];
    }
}
#pragma mark - 内存管理相关
- (void)movieListViewControllerDataInit{
    self.movieList = [[NSMutableArray alloc] initWithCapacity:0];
}
@end
