//
//  IHPSearchViewController.m
//  iHappy
//
//  Created by dusheng.xu on 2017/5/5.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import "IHPSearchViewController.h"
#import "IHPPlayerViewController.h"
#import "IHPMovieCell.h"
@interface IHPSearchViewController ()<UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>
@property (strong, nonatomic) NSMutableArray<IHYMovieModel *> * movieList;
@property (strong, nonatomic) UICollectionView * movieCollectionView;



@property (copy, nonatomic) NSString * firstPageUrl;
@property (copy, nonatomic) NSString * nextPageUrl;


@end

@implementation IHPSearchViewController
NSString * const kSearchViewController_movieCellIdentifier = @"IHPMovieCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self searchViewControllerDataInit];
    [self createSearchViewControllerUI];
}



#pragma mark - UI相关
- (void)createSearchViewControllerUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, DEVIECE_SCREEN_WIDTH*2/3, 40)];
    textField.placeholder = @"视频搜索";
    textField.returnKeyType = UIReturnKeySearch;
    textField.delegate = self;
    self.navigationItem.titleView = textField;
    


    
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
    
    [_movieCollectionView registerNib:[UINib nibWithNibName:kSearchViewController_movieCellIdentifier bundle:nil] forCellWithReuseIdentifier:kSearchViewController_movieCellIdentifier];
    [_movieCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    _movieCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    

    
}

#pragma mark - 网络请求
- (void)loadMoreData{
    if (_nextPageUrl.length) {
        [self fetchMovieList:NO];
    }
}

- (void)fetchMovieList:(BOOL)isTop{
    __weak typeof(self)weakSelf = self;
    [[[XDSHttpRequest alloc] init] htmlRequestWithHref:isTop?_firstPageUrl:_nextPageUrl
                                         hudController:self
                                               showHUD:NO
                                               HUDText:nil
                                         showFailedHUD:YES
                                               success:^(BOOL success, NSData * htmlData) {
                                                   [weakSelf endRefresh];
                                                   if (success) {
                                                       [weakSelf detailHtmlData:htmlData];
                                                   }else{
                                                       [XDSUtilities showHud:@"数据请求失败，请稍后重试" rootView:self.navigationController.view hideAfter:1.2];
                                                   }
                                               } failed:^(NSString *errorDescription) {
                                                   [weakSelf endRefresh];
                                                   
                                               }];
}


#pragma mark - 代理方法
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _movieList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IHPMovieCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kSearchViewController_movieCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    IHYMovieModel * movieModel = _movieList[indexPath.row];
    [cell cellWithMovieModel:movieModel];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    IHYMovieModel * movieModel = _movieList[indexPath.row];
    IHPPlayerViewController * movieDetailVC = [[IHPPlayerViewController alloc] init];
    movieDetailVC.movieModel = movieModel;
    [self.navigationController pushViewController:movieDetailVC animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (!textField.text.length) {
        [XDSUtilities showHud:self.navigationController.view text:@"请输入搜索关键字"];
        return NO;
    }
    [textField resignFirstResponder];
    NSString *url = @"http://www.q2002.com/search?wd=";
    url = [url stringByAppendingString:textField.text];
    self.firstPageUrl = url;
    return YES;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (!searchBar.text.length) {
        [XDSUtilities showHud:self.navigationController.view text:@"请输入搜索关键字"];
        return;
    }
//    [textField resignFirstResponder];
    NSString *url = @"http://www.q2002.com/search?wd=";
    url = [url stringByAppendingString:searchBar.text];
    self.firstPageUrl = url;
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSLog(@"xxxxxxxxxxxxx");
}
#pragma mark - 点击事件处理

#pragma mark - 其他私有方法
- (void)setFirstPageUrl:(NSString *)firstPageUrl{
    _firstPageUrl = firstPageUrl;
    [self fetchMovieList:YES];
}
- (void)endRefresh{
    [_movieCollectionView.mj_header endRefreshing];
    [_movieCollectionView.mj_footer endRefreshing];
}
- (void)detailHtmlData:(NSData *)htmlData{
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
        [_movieList addObjectsFromArray:newMovies];
        [_movieCollectionView reloadData];
    }else{
        [_movieCollectionView.mj_footer endRefreshingWithNoMoreData];
    }
}
#pragma mark - 内存管理相关
- (void)searchViewControllerDataInit{
    self.movieList = [[NSMutableArray alloc] initWithCapacity:0];
}


@end
