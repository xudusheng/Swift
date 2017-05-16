//
//  IHPBiZhiListViewController.m
//  iHappy
//
//  Created by dusheng.xu on 2017/5/13.
//  Copyright © 2017年 上海优蜜科技有限公司. All rights reserved.
//

#import "IHPBiZhiListViewController.h"
#import "YSERequestFetcher.h"
#import "INSImageItemCollectionViewCell.h"
#import "MWPhotoBrowser.h"
@interface IHPBiZhiListViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
MWPhotoBrowserDelegate
>
@property (strong, nonatomic) NSMutableArray<YSEImageModel *> * imageList;
@property (strong, nonatomic) UICollectionView * collectionView;
@property (copy, nonatomic) NSString * nextPageUrl;

@property (strong, nonatomic) MWPhotoBrowser *pictureBrowser;

@end

@implementation IHPBiZhiListViewController
CGFloat const kBiZhiCollectionViewMinimumLineSpacing = 5.0;
CGFloat const kBiZhiCollectionViewMinimumInteritemSpacing = 5.0;
CGFloat const kBiZhiCollectionViewCellsGap = 5.0;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self biZhiListViewControllerDataInit];
    [self createBiZhiListViewControllerUI];
}

#pragma mark - UI相关
- (void)createBiZhiListViewControllerUI{

    self.view.backgroundColor = [UIColor brownColor];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = kBiZhiCollectionViewMinimumLineSpacing;//纵向间距
    flowLayout.minimumInteritemSpacing = kBiZhiCollectionViewMinimumInteritemSpacing;//横向内边距
    
    self.collectionView = ({
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        collectionView.translatesAutoresizingMaskIntoConstraints = false;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[INSImageItemCollectionViewCell class]
           forCellWithReuseIdentifier:kImageItemCollectionViewCellIdentifier];
        
        collectionView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:collectionView];

        NSDictionary *viewsDict = NSDictionaryOfVariableBindings(collectionView);
        NSArray *constraints_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:viewsDict];
        NSArray *constraints_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|" options:NSLayoutFormatAlignAllLeft metrics:nil views:viewsDict];
        
        [self.view addConstraints:constraints_H];
        [self.view addConstraints:constraints_V];
        
        collectionView;
    });

    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                                 refreshingAction:@selector(headerRequest)];
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                                     refreshingAction:@selector(footerRequest)];
    [_collectionView.mj_header beginRefreshing];

}

#pragma mark - 网络请求
#pragma mark - 网络请求
- (void)headerRequest{
    [self fetchImageList:YES];
    [_collectionView.mj_footer resetNoMoreData];
}
- (void)footerRequest{
    if (_nextPageUrl.length) {
        [self fetchImageList:NO];
    }else{
        [_collectionView.mj_footer endRefreshing];
    }
}

- (void)fetchImageList:(BOOL)isTop{
    
    __weak typeof(self)weakSelf = self;
    NSString *url = [_rootUrl stringByAppendingString:isTop?self.firstPageUrl:self.nextPageUrl];
    [[[YSERequestFetcher alloc] init] p_fetchHomePage:url complete:^(YSERequestFetcher *requestFetcher, NSDictionary *responseObj, NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        
        if (responseObj[@"error"] != nil || responseObj == nil) {
            return;
        }
        NSArray *fetchedImageList = responseObj[kBiZhiImageListKey];
        
        isTop?[self.imageList removeAllObjects]:NULL;
        [self.imageList addObjectsFromArray:fetchedImageList];
        [self.collectionView.collectionViewLayout invalidateLayout];
        [self.collectionView reloadData];
        [self saveNextPageInfo:responseObj];
        
        if (self.pictureBrowser.view.window) {
            [self.pictureBrowser reloadData];
            [self.pictureBrowser setCurrentPhotoIndex:self.pictureBrowser.currentIndex];
        }
    }];

}

//TODO:保存下一页的链接
- (void)saveNextPageInfo:(NSDictionary *)result{
    
    NSString *nextPageHref = result[kBiZhiNextPageHrefKey];
    self.nextPageUrl = nextPageHref;

    BOOL isLastPage = [result[kBiZhiIsLastPageKey] boolValue];
    if (isLastPage){
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.collectionView.mj_footer resetNoMoreData];
    }
    
}

//MARK: - Delegate
//TODO:UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageList.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    INSImageItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImageItemCollectionViewCellIdentifier forIndexPath:indexPath];
    YSEImageModel *model = _imageList[indexPath.row];
    cell.imageModel = model;
    [cell p_loadCell];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    YSEImageModel *selectedModel = _imageList[indexPath.row];
    [self showPhotoBrowserWithCurrentPhotoIndex:indexPath.row];

}

//TODO:UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    YSEImageModel *model = _imageList[indexPath.row];
    CGFloat cellWidth  = (DEVIECE_SCREEN_WIDTH - 4*kBiZhiCollectionViewCellsGap)/3;
    CGFloat cellHeight = [self getCellHeightWithImageModel:model width:cellWidth];
    return CGSizeMake(cellWidth, cellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(kBiZhiCollectionViewCellsGap, kBiZhiCollectionViewCellsGap, 0, kBiZhiCollectionViewCellsGap);
}

//TODO:MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return _imageList.count;
}
- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    if (index < _imageList.count) {
        YSEImageModel *model = _imageList[index];
        NSString *image_url = model.href;
        NSString *subfix = @"jpg";
        image_url = [image_url componentsSeparatedByString:subfix].firstObject;
        image_url = [image_url stringByAppendingString:subfix];
        
        NSURL *url = [NSURL URLWithString:image_url];
        MWPhoto *photo = [MWPhoto photoWithURL:url];
        photo.caption = model.title;
        return photo;
    }
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index{
    if (index == _imageList.count - 1) {
        [self footerRequest];
    }
}

#pragma mark - 点击事件处理
//TODO: showPhotoBrowser
- (void)showPhotoBrowserWithCurrentPhotoIndex:(NSInteger)currentPhotoIndex{

    // Create browser
    [self.pictureBrowser setCurrentPhotoIndex:currentPhotoIndex];
    [self.navigationController pushViewController:self.pictureBrowser animated:YES];
}

- (MWPhotoBrowser *)pictureBrowser{
    if (nil == _pictureBrowser) {
        _pictureBrowser = ({
            BOOL displayActionButton = true;
            BOOL displaySelectionButtons = false;
            BOOL displayNavArrows = false;
            BOOL enableGrid = true;
            BOOL startOnGrid = false;
            BOOL autoPlayOnAppear = false;
            MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] init];
            browser.delegate = self;
            browser.displayActionButton = displayActionButton;
            browser.displayNavArrows = displayNavArrows;
            browser.displaySelectionButtons = displaySelectionButtons;
            browser.alwaysShowControls = displaySelectionButtons;
            browser.zoomPhotosToFill = true;
            browser.enableGrid = enableGrid;
            browser.startOnGrid = startOnGrid;
            browser.enableSwipeToDismiss = true;
            browser.autoPlayOnAppear = autoPlayOnAppear;
            browser;
        });
    }
    return _pictureBrowser;
}
#pragma mark - 其他私有方法
//TODO:getCellHeight
- (CGFloat)getCellHeightWithImageModel:(YSEImageModel *)imageModel width:(CGFloat)width{
    CGFloat imageHeight = imageModel.height.floatValue;
    CGFloat imageWidth = imageModel.width.floatValue;
    return (imageHeight * width / imageWidth);
}

#pragma mark - 内存管理相关
- (void)biZhiListViewControllerDataInit{
    self.imageList = [NSMutableArray arrayWithCapacity:0];
}


@end
