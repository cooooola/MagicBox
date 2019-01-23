//
//  CCVIPViewingViewController.m
//  MagicBox
//
//  Created by hello on 2018/11/7.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCVIPViewingViewController.h"
#import "CCVIPViewingCollectionViewCell.h"
#import "CCWebViewController.h"

static NSString *APIIQIYI = @"http://m.iqiyi.com";//爱奇艺
static NSString *APIYOUKU = @"https://www.youku.com";//优酷
static NSString *APITENXUN = @"https://m.v.qq.com";//腾讯
static NSString *APILESHI = @"https://m.le.com";//乐视
static NSString *APIPPTV = @"http://m.pptv.com";//PPTV
static NSString *APIMGTV = @"https://m.mgtv.com";//芒果TV
static NSString *APIM1905 = @"http://m.1905.com";//M1905
static NSString *APISHSP = @"https://m.tv.sohu.com";//搜狐视频
static NSString *APIMGSP = @"http://movie.miguvideo.com";//咪咕视频
static NSString *APILISP = @"http://www.pearvideo.com";//梨视频


@interface CCVIPViewingViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *apiArray;
@end

@implementation CCVIPViewingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray arrayWithObjects:@"爱奇艺",@"优酷",@"腾讯视频",@"乐视",@"PPTV",@"芒果TV",@"M1905",@"搜狐视频",@"咪咕视频",@"梨视频", nil];
    self.apiArray = [NSMutableArray arrayWithObjects:APIIQIYI,APIYOUKU,APITENXUN,APILESHI,APIPPTV,APIMGTV,APIM1905,APISHSP,APIMGSP,APILISP, nil];
}

-(void)initView{
    self.title = @"VIP观影";
    self.navigationItem.leftBarButtonItem = self.customLeftItem;
    self.view.backgroundColor = MCUIColorFromRGB(0xe9e9e9);
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        CGFloat itemW = (MCScreenWidth-3)/4;
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(itemW,itemW);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 0;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.backgroundColor = MCUIColorFromRGB(0xe9e9e9);
        [self.collectionView registerClass:[CCVIPViewingCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
    }
    return _collectionView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCVIPViewingCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.nameString = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CCWebViewController *wvc = [[CCWebViewController alloc]init];
    wvc.title = [self.dataArray objectAtIndex:indexPath.row];
    wvc.urlString = [self.apiArray objectAtIndex:indexPath.row];
    wvc.webViewType = WebViewTypeFooterView;
    [self.navigationController pushViewController:wvc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
