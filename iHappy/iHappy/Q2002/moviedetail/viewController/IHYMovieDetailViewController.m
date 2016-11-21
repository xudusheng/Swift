//
//  IHYMovieDetailViewController.m
//  iHappy
//
//  Created by xudosom on 2016/11/20.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

#import "IHYMovieDetailViewController.h"
#import "IHYMovieInfoHeaderView.h"
#import "IHYMoviePlayButtonModel.h"
#import "IHYMoviePlayButtonCell.h"
#import "IHYMoviePlayerViewController.h"
@interface IHYMovieDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) NSMutableArray<NSDictionary *> * movieButtonList;
@property (strong, nonatomic) UICollectionView * moviedetailCollectionView;

@property (strong, nonatomic) IHYMovieInfoHeaderView * movieInfoHeaderView;
@end

@implementation IHYMovieDetailViewController
- (void)dealloc{
    NSLog(@"%@ ==> dealloc", [self class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self movieDetailViewControllerDataInit];
    [self createMovieDetailViewControllerUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
#pragma mark - UI相关
- (void)createMovieDetailViewControllerUI{
    [self.navigationController.navigationBar setTranslucent:NO];
    self.view.backgroundColor = [UIColor whiteColor];
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小
    CGFloat width = 60;
    layout.itemSize = CGSizeMake(width, 30);
    //创建collectionView 通过一个布局策略layout来创建
    self.moviedetailCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _moviedetailCollectionView.backgroundColor = [UIColor whiteColor];
    
    //代理设置
    _moviedetailCollectionView.delegate=self;
    _moviedetailCollectionView.dataSource=self;
    //注册item类型 这里使用系统的类型
    [self.view addSubview:_moviedetailCollectionView];
    
    [_moviedetailCollectionView registerClass:[IHYMoviePlayButtonCell class] forCellWithReuseIdentifier:@"cell"];
    [_moviedetailCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    
    self.movieInfoHeaderView = [[IHYMovieInfoHeaderView alloc] initWithFrame: CGRectMake(0, -IHYMovieDetailInfoViewInitialHeight, DEVIECE_SCREEN_WIDTH, IHYMovieDetailInfoViewInitialHeight)];
    
    _moviedetailCollectionView.contentInset = UIEdgeInsetsMake(IHYMovieDetailInfoViewInitialHeight, 0, 100, 0);
    [_moviedetailCollectionView addSubview:_movieInfoHeaderView];
    
    [self fetchMovieInfo];
    
}

#pragma mark - 网络请求
- (void)fetchMovieInfo{
    
    __weak typeof(self)weakSelf = self;
    [[[XDSHttpRequest alloc] init] htmlRequestWithHref:_movieModel.href
                                         hudController:self
                                               showHUD:YES
                                               HUDText:nil
                                         showFailedHUD:YES
                                               success:^(BOOL success, NSData * htmlData) {
                                                   NSLog(@"utf8 = %@", [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding]);
                                                   [weakSelf detailHtmlData:htmlData];
                                               } failed:^(NSString *errorDescription) {
                                                   
                                               }];
    
}
#pragma mark - 代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _movieButtonList.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDictionary * buttonList_section = _movieButtonList[section];
    
    return [buttonList_section[@"buttonLies"] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IHYMoviePlayButtonCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary * buttonList_section = _movieButtonList[indexPath.section];
    NSArray * buttonList = buttonList_section[@"buttonLies"];
    IHYMoviePlayButtonModel * buttonModel = buttonList[indexPath.row];
    
    cell.titleLabel.text = buttonModel.title;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * buttonList_section = _movieButtonList[indexPath.section];
    NSArray * buttonList = buttonList_section[@"buttonLies"];
    IHYMoviePlayButtonModel * buttonModel = buttonList[indexPath.row];
    IHYMoviePlayerViewController * playerVC = [[IHYMoviePlayerViewController alloc] init];
    playerVC.movieSrc = buttonModel.playerHref;
    [self.navigationController pushViewController:playerVC animated:YES];
}
#pragma mark - 点击事件处理

#pragma mark - 其他私有方法

- (void)detailHtmlData:(NSData *)htmlData{
    TFHpple * hpp = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    NSArray * img_lazy_elments = [hpp searchWithXPathQuery:@"//img[@class=\"lazy\"]"];
    NSString * movieImage = @"";
    if (img_lazy_elments.count > 0) {
        TFHppleElement * img_lazy_elment = img_lazy_elments.firstObject;
        movieImage = [img_lazy_elment objectForKey:@"src"];
    }
    
    NSArray * dt_dd_elements = [hpp searchWithXPathQuery:@"//dl//dt|//dd"];
    NSMutableArray * titleAndContentModels = [NSMutableArray arrayWithCapacity:0];
    for (TFHppleElement * dt_dd_element in dt_dd_elements) {
        NSString * content = dt_dd_element.text;
        NSString * title = [dt_dd_element firstChildWithTagName:@"span"].text;
        NSLog(@"%@ = %@\n", title, content);
        IHYMovieDetailInfoTitleAndContentModel * model = [[IHYMovieDetailInfoTitleAndContentModel alloc] init];
        model.title = title;
        model.content = content;
        [titleAndContentModels addObject:model];
    }

    
    TFHppleElement * sumary_element = [hpp searchWithXPathQuery:@"//div[@class=\"tab-jq ctc\"]"].firstObject;
    NSString * sumary = sumary_element.text;
    NSLog(@"%@", sumary);
    
    CGFloat sumaryHeight = [XDSUtilities heightForString:sumary
                                              limitWidth:DEVIECE_SCREEN_WIDTH - 20
                                                    font:[UIFont systemFontOfSize:13]];
    CGRect headerViewFrame =CGRectZero;
    NSLog(@"frame = %@", NSStringFromCGRect(_movieInfoHeaderView.frame));
    headerViewFrame.size.width = DEVIECE_SCREEN_WIDTH;
    headerViewFrame.size.height = IHYMovieDetailInfoViewInitialHeight + sumaryHeight;
    headerViewFrame.origin.y = -headerViewFrame.size.height;
    _movieInfoHeaderView.frame = headerViewFrame;
    NSLog(@"frame = %@", NSStringFromCGRect(_movieInfoHeaderView.frame));
    NSLog(@"contentInset = %@", NSStringFromUIEdgeInsets(_moviedetailCollectionView.contentInset));
    _moviedetailCollectionView.contentInset = UIEdgeInsetsMake(headerViewFrame.size.height, 0, 100, 0);
    NSLog(@"contentInset = %@", NSStringFromUIEdgeInsets(_moviedetailCollectionView.contentInset));
    
    [_movieInfoHeaderView movieInfoHeaderWithMovieImage:movieImage
                                                 sumary:sumary
                                  titlaAndContentModels:titleAndContentModels];
    
    NSArray * show_player_gogo_elements = [hpp searchWithXPathQuery:@"//div[@class=\"show_player_gogo\"]//ul"];
    NSArray * bofangqi_elements = [hpp searchWithXPathQuery:@"//li[@class=\"on bofangqi\"]"];
    NSMutableArray * bofangqi = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < show_player_gogo_elements.count; i ++) {
        TFHppleElement * show_player_gogo_element = show_player_gogo_elements[i];
        NSString * playerDesc = @"";
        if (i < bofangqi_elements.count) {
            TFHppleElement * bofangqi_element = bofangqi_elements[i];
            playerDesc = bofangqi_element.text;
        }
        NSLog(@"%@", playerDesc);
        NSMutableArray * buttonArray = [NSMutableArray arrayWithCapacity:0];
        NSArray * button_li_elements = [show_player_gogo_element childrenWithTagName:@"li"];
        for (TFHppleElement * button_li_element in button_li_elements) {
            TFHppleElement * button_a_element = [button_li_element firstChildWithTagName:@"a"];
            NSString * href = [button_a_element objectForKey:@"href"];
            NSString * buttonTitle = button_a_element.text;
            NSLog(@"%@ = %@", buttonTitle, href);
            if (!href || !buttonTitle) {
                continue;
            }
            IHYMoviePlayButtonModel * buttonModel = [[IHYMoviePlayButtonModel alloc] init];
            [buttonModel setValuesForKeysWithDictionary:@{@"title":buttonTitle, @"playerHref":href}];
            [buttonArray addObject:buttonModel];
        }
        
        [bofangqi addObject:@{@"title":playerDesc, @"buttonLies":buttonArray}];
    }
    
    NSArray * footer_elements = [hpp searchWithXPathQuery:@"//div[@class=\"footer clearfix\"]//p"];
    NSMutableString * footerDisc = [NSMutableString string];
    for (TFHppleElement * p_element in footer_elements) {
        NSString * text = p_element.text;
        [footerDisc appendString:text];
        [footerDisc appendString:@"\n"];
    };
    NSLog(@"%@", footerDisc);
    
    
    if (bofangqi.count > 0) {
        [_movieButtonList removeAllObjects];
        [_movieButtonList addObjectsFromArray:bofangqi];
        [_moviedetailCollectionView reloadData];
    }
}

#pragma mark - 内存管理相关
- (void)movieDetailViewControllerDataInit{
    self.movieButtonList = [[NSMutableArray alloc] init];
    
}



@end
