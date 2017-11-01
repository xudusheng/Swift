//
//  IHPPlayerViewController.m
//  iHappy
//
//  Created by xudosom on 2017/5/5.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import "IHPPlayerViewController.h"
#import "IHYMovieInfoHeaderView.h"
#import "IHYMoviePlayButtonModel.h"
#import "IHYMoviePlayButtonCell.h"
#import "AppDelegate.h"
//#import "IHYMoviePlayerViewController.h"
//#import "ZFPlayer.h"
@interface IHPPlayerViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIWebViewDelegate
>
@property (strong, nonatomic) NSMutableArray<NSDictionary *> * movieButtonList;
@property (strong, nonatomic) UICollectionView * moviedetailCollectionView;

//@property (strong, nonatomic) ZFPlayerView *playerView;
@property (strong, nonatomic) UIView *playerContentView;

@property (strong, nonatomic) UIWebView * webView;
@property (nonatomic,assign)BOOL didWebViewLoadOK;

@property (strong, nonatomic) IHYMoviePlayButtonModel *selectedMovieModel;

@end

@implementation IHPPlayerViewController
- (void)dealloc{
    NSLog(@"%@ ==> dealloc", [self class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self movieDetailViewControllerDataInit];
    [self createMovieDetailViewControllerUI];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];// 播放器即将播放通知

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen:) name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];// 播放器即将退出通知

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen:) name:UIWindowDidBecomeVisibleNotification object:nil];//进入全屏
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen:) name:UIWindowDidBecomeHiddenNotification object:nil];//退出全屏

}
#pragma - mark  进入全屏
-(void)begainFullScreen:(NSNotification *)noti {
    if(!self.didWebViewLoadOK) {
        return;
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = YES;

    [[UIDevice currentDevice] setValue:@"UIInterfaceOrientationLandscapeLeft" forKey:@"orientation"];

    //强制zhuan'p：
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeLeft;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}


#pragma - mark 退出全屏
-(void)endFullScreen:(NSNotification *)noti {
    if(!self.didWebViewLoadOK) {
        return;
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = NO;

    //强制归正：
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val =UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
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
//    layout.itemSize = CGSizeMake(width, 30);
    layout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 10);
    layout.minimumLineSpacing = 10;
    layout.estimatedItemSize = CGSizeMake(30, width);

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


    self.playerContentView = [[UIView alloc] initWithFrame: CGRectMake(0, -IHYMovieDetailInfoViewInitialHeight, DEVIECE_SCREEN_WIDTH, IHYMovieDetailInfoViewInitialHeight)];
    self.playerContentView.backgroundColor = [UIColor blackColor];
    self.webView = [[UIWebView alloc]initWithFrame:self.playerContentView.bounds];
    self.webView.mediaPlaybackRequiresUserAction = YES;
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:_webView];

    _moviedetailCollectionView.contentInset = UIEdgeInsetsMake(IHYMovieDetailInfoViewInitialHeight, 0, 100, 0);
    [_moviedetailCollectionView addSubview:self.playerContentView];

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

#pragma mark - 网络请求
//TODO: 请求播放页面
- (void)fetchMoviePlayer{
    __weak typeof(self)weakSelf = self;
    [[[XDSHttpRequest alloc] init] htmlRequestWithHref:self.selectedMovieModel.playerHref
                                         hudController:self
                                               showHUD:YES
                                               HUDText:nil
                                         showFailedHUD:YES
                                               success:^(BOOL success, NSData * htmlData) {
                                                   [weakSelf dealPlayerData:htmlData];
                                               } failed:^(NSString *errorDescription) {

                                               }];

}

#pragma mark - 代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _movieButtonList.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDictionary * buttonList_section = _movieButtonList[section];

    return [buttonList_section[@"buttonList"] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IHYMoviePlayButtonCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSDictionary * buttonList_section = _movieButtonList[indexPath.section];
    NSArray * buttonList = buttonList_section[@"buttonList"];
    IHYMoviePlayButtonModel * buttonModel = buttonList[indexPath.row];
    cell.titleLabel.text = buttonModel.title;

    cell.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    cell.layer.cornerRadius = 3;
    cell.layer.masksToBounds = YES;
    cell.titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    if (buttonModel == self.selectedMovieModel) {
        cell.titleLabel.textColor = [UIColor redColor];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * buttonList_section = _movieButtonList[indexPath.section];
    NSArray * buttonList = buttonList_section[@"buttonList"];
    IHYMoviePlayButtonModel * buttonModel = buttonList[indexPath.row];
    self.selectedMovieModel = buttonModel;
//    IHYMoviePlayerViewController * playerVC = [[IHYMoviePlayerViewController alloc] init];
//    playerVC.movieSrc = buttonModel.playerHref;
//    [self.navigationController pushViewController:playerVC animated:YES];
}



-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.didWebViewLoadOK = YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.didWebViewLoadOK = NO;
}

#pragma mark - 事件处理
- (void)orientChange:(NSNotification *)notification {
    UIDeviceOrientation orient = [UIDevice currentDevice].orientation;

    NSLog(@"notification = %@", notification.userInfo);
    NSLog(@"orient = %@", @(orient));
}
#pragma mark - 其他私有方法
//TODO:解析视频信息与选集
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
            if (!href || !buttonTitle || [buttonTitle containsString:@"更多"]) {
                continue;
            }
            IHYMoviePlayButtonModel * buttonModel = [[IHYMoviePlayButtonModel alloc] init];
            [buttonModel setValuesForKeysWithDictionary:@{@"title":buttonTitle, @"playerHref":href}];
            [buttonArray addObject:buttonModel];
        }

        [bofangqi addObject:@{@"title":playerDesc, @"buttonList":buttonArray}];
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


    if (_movieButtonList.count) {
        NSDictionary * buttonList_section = _movieButtonList.firstObject;
        NSArray * buttonList = buttonList_section[@"buttonList"];
        if (buttonList.count) {
            IHYMoviePlayButtonModel * buttonModel = buttonList.firstObject;
            self.selectedMovieModel = buttonModel;
        }
    }

}

//TODO:解析播放器代码
- (void)dealPlayerData:(NSData *)PlayerData{
    TFHpple * hpp = [[TFHpple alloc] initWithHTMLData:PlayerData];
    TFHppleElement * iframe = [hpp searchWithXPathQuery:@"//iframe"].firstObject;
    if (iframe != nil) {
        NSString * playerSrc = [iframe objectForKey:@"src"];

        __weak typeof(self)weakSelf = self;
        [[[XDSHttpRequest alloc] init] htmlRequestWithHref:playerSrc
                                             hudController:self
                                                   showHUD:YES
                                                   HUDText:nil
                                             showFailedHUD:YES
                                                   success:^(BOOL success, NSData * htmlData) {
                                                       NSLog(@"%@", [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding]);
                                                       [weakSelf stripVideoSrc:htmlData playerUrl:playerSrc];
                                                   } failed:^(NSString *errorDescription) {

                                                   }];
    }
}

//TODO:解析获取视频地址
- (void)stripVideoSrc:(NSData *)data playerUrl:(NSString *)playerUrl{
    TFHpple * hpp = [[TFHpple alloc] initWithHTMLData:data];
    TFHppleElement * video = [hpp searchWithXPathQuery:@"//video"].firstObject;
    BOOL playerWebView = YES;
    NSString *videoUrl = @"";
    if (video != nil) {
        videoUrl = [video objectForKey:@"src"];
        if (videoUrl.length) {
            playerWebView = NO;
        }
    }

    
    //======================纯webView显示====================
    if (!self.webView.superview) {
        [self.playerContentView addSubview:self.webView];
    }
    NSURL * url = [NSURL URLWithString:playerUrl];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    //====================== player + webView显示 ====================
    //    if (playerWebView) {
    //        [self.playerView removeFromSuperview];
    //        if (!self.webView.superview) {
    //            [self.playerContentView addSubview:self.webView];
    //        }
    //        NSURL * url = [NSURL URLWithString:playerUrl];
    //        NSURLRequest * request = [NSURLRequest requestWithURL:url];
    //        [_webView loadRequest:request];
    //    }else{
    //        [self.webView removeFromSuperview];
    //        if (![self.playerView superview]) {
    //            [self.playerContentView addSubview:self.playerView];
    //        }
    //
    //        [self playWithZPPLayer:videoUrl];
    //    }

    self.title = [NSString stringWithFormat:@"%@-%@", self.movieModel.name, self.selectedMovieModel.title];
    [self.moviedetailCollectionView cw_scrollToTopAnimated:YES];
    [self.moviedetailCollectionView reloadData];
}


//- (void)playWithZPPLayer:(NSString *)videoSrc{
//
//    NSURL *videoURL = [NSURL URLWithString:videoSrc];
//    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
//    playerModel.title            = self.selectedMovieModel.title;
//    playerModel.videoURL         = videoURL;
//    playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
//    playerModel.fatherView       = self.playerContentView;
//
//    [self.playerView playerControlView:nil playerModel:playerModel];
//}

- (void)setSelectedMovieModel:(IHYMoviePlayButtonModel *)selectedMovieModel{
    _selectedMovieModel = selectedMovieModel;
//    [self.playerView resetPlayer];
    [self fetchMoviePlayer];
}


//- (ZFPlayerView *)playerView{
//    if (!_playerView) {
//        _playerView = [[ZFPlayerView alloc] init];
//
//        /*****************************************************************************************
//         *   // 指定控制层(可自定义)
//         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
//         *   // 设置控制层和播放模型
//         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
//         *   // 等效于 [_playerView playerModel:self.playerModel];
//         ******************************************************************************************/
////        [_playerView playerControlView:nil playerModel:playerModel];
//
//        // 设置代理
//        //    playerView.delegate = self;
//
//        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
//        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
//
//        // 打开下载功能（默认没有这个功能）
//        _playerView.hasDownload    = YES;
//
//        // 打开预览图
//        _playerView.hasPreviewView = YES;
//    }
//    return _playerView;
//
//}
#pragma mark - 内存管理相关
- (void)movieDetailViewControllerDataInit{
    self.movieButtonList = [[NSMutableArray alloc] init];

}

@end
