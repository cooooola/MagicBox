//
//  CCLivePlatformViewController.m
//  MagicBox
//
//  Created by hello on 2018/11/5.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCLivePlatformViewController.h"
#import "CCLivePlatformHeaderView.h"
#import "CCLivePlatformCollectionViewCell.h"
#import "CCLivePlatformModel.h"
#import "CCLiveBroadcastViewController.h"
#import "CCPlayerViewController.h"

@interface CCLivePlatformViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)CCLivePlatformHeaderView *livePlatformHeaderView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation CCLivePlatformViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initData];
}

-(void)initView{
    
    self.view.backgroundColor = MCUIColorFromRGB(0xe9e9e9);
    
    [self.view addSubview:self.livePlatformHeaderView];
    [self.livePlatformHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.view);
        make.height.equalTo(@270);
    }];
    
    [self.view addSubview:self.returnBurron];
    [self.returnBurron mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(MCStatusBarHeight+5);
        make.left.equalTo(self.view).offset(10);
        make.width.height.equalTo(@40);
    }];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.livePlatformHeaderView.mas_bottom).offset(5);
    }];
    
}

-(CCLivePlatformHeaderView *)livePlatformHeaderView{
    if (!_livePlatformHeaderView) {
        _livePlatformHeaderView = [[CCLivePlatformHeaderView alloc]init];
    }
    return _livePlatformHeaderView;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        CGFloat itemW = (MCScreenWidth-5)/2;
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(itemW,itemW);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 0;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionView.backgroundColor = MCUIColorFromRGB(0xe9e9e9);
        [self.collectionView registerClass:[CCLivePlatformCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self initData];
        }];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CCLivePlatformCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.livePlatformModel = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [CCMineManage MineMemberInspectionWithViewController:self Completion:^(BOOL MemberStatus) {
        if (MemberStatus) {
            CCPlayerViewController *pvc = [[CCPlayerViewController alloc]initWithVideos:self.dataArray index:indexPath.row];
            //            - (instancetype)initWithVideos:(NSArray *)videos index:(NSInteger)index;
            //            CCLiveBroadcastViewController *lbvc = [[CCLiveBroadcastViewController alloc]init];
            //            lbvc.livePlatformModel = [self.dataArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:pvc animated:YES];
        }
    }];
//    [CCMineManage MineMemberInspectionCompletion:^(BOOL MemberStatus) {
//        if (MemberStatus) {
//            CCPlayerViewController *pvc = [[CCPlayerViewController alloc]initWithVideos:self.dataArray index:indexPath.row];
////            - (instancetype)initWithVideos:(NSArray *)videos index:(NSInteger)index;
////            CCLiveBroadcastViewController *lbvc = [[CCLiveBroadcastViewController alloc]init];
////            lbvc.livePlatformModel = [self.dataArray objectAtIndex:indexPath.row];
//            [self.navigationController pushViewController:pvc animated:YES];
//        }
//    }];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)setLiveModel:(CCLiveModel *)liveModel{
    _liveModel = liveModel;
    self.livePlatformHeaderView.platformName = liveModel.title;
    self.livePlatformHeaderView.platformImageString = liveModel.img;
    
}

-(void)initData{
    [self.emptyView removeFromSuperview];
    [CCMineManage MinePlatformDataWithName:_liveModel.name completion:^(id resultDictionary, NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        if (error) {
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"网络错误，请稍后再试！"];
            [self showEmptyView];
        }else{
            if (![resultDictionary isKindOfClass:[NSNull class]]) {
                [self.dataArray removeAllObjects];
                NSArray *array = [NSArray arrayWithArray:resultDictionary];
                for (int i = 0 ; i < array.count ; i++) {
                    CCLivePlatformModel *model = [CCLivePlatformModel modelWithDictionary:[array objectAtIndex:i]];
                    [self.dataArray addObject:model];
                }
            }
            self.livePlatformHeaderView.platformNumber = [NSString stringWithFormat:@"%lu",(unsigned long)self.dataArray.count];
            [self.collectionView reloadData];
            if (self.dataArray.count == 0) {
                [self showEmptyView];
            }
        }
    }];
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
