//
//  CCLiveViewController.m
//  MagicBox
//
//  Created by hello on 2018/11/2.
//  Copyright © 2018年 hello. All rights reserved.
//
#define gIv @"7DJgTLRZ17WLTm18"
NSString *const kInitVector = @"7DJgTLRZ17WLTm18";
//size_t const kKeySize = kCCKeySizeAES128;

#import "CCLiveViewController.h"
#import "SDCycleScrollView.h"
#import "CCLiveCollectionViewCell.h"
#import "CCLiveHeaderView.h"
#import "CCLivePlatformViewController.h"
#import "CCLiveModel.h"

#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import "AESCrypt.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "NSData+CommonCrypto.h"

#import "CCJsonTool.h"

@interface CCLiveViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate,SDCycleScrollViewDelegate>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)CCLiveHeaderView *liveHeaderView;
@property(nonatomic,strong)SDCycleScrollView *bannerView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *imageArray;

@end

@implementation CCLiveViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getAd];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self getAd];
    
}


-(void)initView{
    self.navigationItem.title = @"大黄鸭";
    self.view.backgroundColor = MCUIColorFromRGB(0xe9e9e9);
    
    [self setupBannerView];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.bannerView.mas_bottom).offset(10);
    }];
}

-(void)setupBannerView{
    _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10,10, MCScreenWidth-20, kAdapterWith(140)) delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
    [self.view addSubview:_bannerView];
    _bannerView.showPageControl = YES;
    _bannerView.imageURLStringsGroup = [NSArray arrayWithArray:_imageArray];
    _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        CGFloat itemW = (MCScreenWidth-2)/3;
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(itemW,itemW);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 0;
        layout.headerReferenceSize = CGSizeMake(MCScreenWidth, 40);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.backgroundColor = MCUIColorFromRGB(0xe9e9e9);
        [self.collectionView registerClass:[CCLiveCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self initData];
        }];
    }
    return _collectionView;
}

-(CCLiveHeaderView *)liveHeaderView{
    if (!_liveHeaderView) {
        _liveHeaderView = [[CCLiveHeaderView alloc]init];
    }
    return _liveHeaderView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCLiveCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.liveModel = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    [headerView addSubview:self.liveHeaderView];
    [self.liveHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerView);
    }];
    return headerView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CCLivePlatformViewController *lpvc = [[CCLivePlatformViewController alloc]init];
    lpvc.liveModel = [self.dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:lpvc animated:YES];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)initData{
    [self.emptyView removeFromSuperview];
    [CCMineManage MineLivePlatformCompletion:^(id resultDictionary, NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        if (error) {
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"网络错误，请稍后再试！"];
            [self showEmptyView];
        }else{
            if (![resultDictionary isKindOfClass:[NSNull class]]) {
                [self.dataArray removeAllObjects];
                NSArray *array = [resultDictionary objectForKey:@"data"];
                for (int i = 0 ; i < array.count ; i++) {
                    CCLiveModel *model = [CCLiveModel modelWithDictionary:[array objectAtIndex:i]];
                    [self.dataArray addObject:model];
                }
                [self.collectionView reloadData];
                if (self.dataArray.count == 0) {
                    [self showEmptyView];
                }
                self.liveHeaderView.liveNumber = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataArray.count];
            }
        }
    }];
}

-(void)getAd{
    NSArray *array = [AppDelegate sharedApplicationDelegate].fileConfigurationModel.silderadv;
    _imageArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i ++) {
        CCSilderadvModel *model = [array objectAtIndex:i];
        [_imageArray addObject:model.slide_pic];
    }
    _bannerView.imageURLStringsGroup = [NSArray arrayWithArray:_imageArray];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    CCSilderadvModel *model = [[AppDelegate sharedApplicationDelegate].fileConfigurationModel.silderadv objectAtIndex:index];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.slide_url]];
}

-(void)showEmptyView{
    [self.emptyView removeFromSuperview];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.collectionView);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
