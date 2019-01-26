//
//  CCCloudBroadcastListViewController.m
//  MagicBox
//
//  Created by hello on 2018/11/10.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCCloudBroadcastListViewController.h"
#import "CCLivePlatformCollectionViewCell.h"
#import "CCCloudBroadcastListModel.h"

#import "HJVideoPlayerController.h"
#import "CCCloudBroadcastModel.h"
#import "HttpService.h"
#import "CCJsonTool.h"


@interface CCCloudBroadcastListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *playArray;
@end

@implementation CCCloudBroadcastListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)initView{
    self.navigationItem.leftBarButtonItem = self.customLeftItem;
    self.view.backgroundColor = MCUIColorFromRGB(0xe9e9e9);
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)setBroadcastModel:(CCBroadcastModel *)broadcastModel{
    _broadcastModel = broadcastModel;
    
    self.title = broadcastModel.uname;
    self.page = 1;
    [self initData];
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        CGFloat itemW = (MCScreenWidth-10)/3;
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
            self->_page = 1;
            [self initData];
        }];
        self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.page ++;
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
    cell.numberView.hidden = YES;
    cell.cloudBroadcastListModel = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [CCMineManage MineMemberInspectionWithViewController:self Completion:^(BOOL MemberStatus) {
        if (MemberStatus) {
            CCCloudBroadcastListModel *model = [self.dataArray objectAtIndex:indexPath.row];
            if (self->_cloudBroadcastType == CloudBroadcastTypePronHhub) {
                [self pornhubPlayVideoWithVideoModel:model];
            }else if(self->_cloudBroadcastType == CloudBroadcastTypeXhgdy){
                [self xhgPlayVideoWithVideoModel:model];
            }else{
                [self avPlayVideoWithVideoModel:model];
            }
        }
    }];
//    [CCMineManage MineMemberInspectionCompletion:^(BOOL MemberStatus) {
//        if (MemberStatus) {
//            CCCloudBroadcastListModel *model = [self.dataArray objectAtIndex:indexPath.row];
//            if (self->_cloudBroadcastType == CloudBroadcastTypePronHhub) {
//                [self pornhubPlayVideoWithVideoModel:model];
//            }else if(self->_cloudBroadcastType == CloudBroadcastTypeXhgdy){
//                [self xhgPlayVideoWithVideoModel:model];
//            }else{
//                [self avPlayVideoWithVideoModel:model];
//            }
//        }
//    }];
}

-(void)initData{
    NSString *uid;
    if (_cloudBroadcastType == CloudBroadcastTypeEnterAVdy) {
        uid = _broadcastModel.cid;
    }else{
        uid = _broadcastModel.uid;
    }
    if (self.dataArray.count == 0) {
        [CCView BSMBProgressHUD_bufferAndTextWithView:self.view andText:nil];
    }
    [CCMineManage MineCloudBroadcastListWithCloudBroadcastType:_cloudBroadcastType andUid:uid andPage:self.page Completion:^(id resultDictionary, NSError *error) {
        [CCView BSMBProgressHUD_hideWith:self.view];
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        if (error) {
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"网络错误，请销后再试！"];
        }else{
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            NSArray *array = [resultDictionary objectForKey:@"data"];
            if (array.count < 20) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            for (int i = 0; i < array.count; i++) {
                CCCloudBroadcastListModel *model = [CCCloudBroadcastListModel modelWithDictionary:[array objectAtIndex:i]];
                [self.dataArray addObject:model];
            }
            [self.collectionView reloadData];
        }
    }];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma pornhub播放
-(void)pornhubPlayVideoWithVideoModel:(CCCloudBroadcastListModel *)videoModel{
    [CCView BSMBProgressHUD_bufferAndTextWithView:self.view andText:@"资源加载，请稍候..."];
    [CCMineManage MineHubPlayWithViewKey:videoModel.viewkey Completion:^(id resultDictionary, NSError *error) {
        [CCView BSMBProgressHUD_hideWith:self.view];
        if (error) {
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"网络错误，请稍后再试！"];
        }else{
            NSString *code = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"code"]];
            if ([code isEqualToString:@"1000"]) {
                NSArray *array = [resultDictionary objectForKey:@"data"];
                self.playArray = [NSMutableArray array];
                for (int i = 0; i < array.count; i ++ ) {
                    CCCloudBroadcastModel *model = [CCCloudBroadcastModel modelWithDictionary:[array objectAtIndex:i]];
                    [self.playArray addObject:model];
                }
                
                if (self.playArray.count > 1) {
                    CCCloudBroadcastModel *model = [self.playArray objectAtIndex:1];
                    [self playWithUrl:model.videoUrl andTitle:videoModel.title];
                }
            }
        }
    }];
}

#pragma 小黄瓜播放
-(void)xhgPlayVideoWithVideoModel:(CCCloudBroadcastListModel *)videoModel{
    [CCView BSMBProgressHUD_bufferAndTextWithView:self.view andText:@"资源加载，请稍候..."];
    [CCMineManage MineXHGPlayWithId:videoModel.Id Completion:^(id resultDictionary, NSError *error) {
        [CCView BSMBProgressHUD_hideWith:self.view];
        if (error) {
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"网络错误，请稍后再试！"];
        }else{
            NSString *code = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"code"]];
            if ([code isEqualToString:@"1000"]) {
                NSDictionary *dic = [resultDictionary objectForKey:@"data"];
                NSString *playurl = [dic objectForKey:@"url"];
                NSString *playtitle = [dic objectForKey:@"title"];
                [self playWithUrl:playurl andTitle:playtitle];
            }
        }
    }];
}

#pragma av播族
-(void)avPlayVideoWithVideoModel:(CCCloudBroadcastListModel *)videoModel{
    [CCView BSMBProgressHUD_bufferAndTextWithView:self.view andText:@"资源加载，请稍候..."];
    [CCMineManage MineAVPlayWithId:videoModel.Id Completion:^(id resultDictionary, NSError *error) {
        [CCView BSMBProgressHUD_hideWith:self.view];
        if (error) {
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"网络错误，请稍后再试！"];
        }else{
            NSString *code = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"code"]];
            if ([code isEqualToString:@"1000"]) {
                NSString *titlestring = videoModel.title;
                [self playWithUrl:[resultDictionary objectForKey:@"url"] andTitle:titlestring];
            }else{
                [CCView BSMBProgressHUD_hideWith:self.view];
                NSString *msg = [resultDictionary objectForKey:@"msg"];
                [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:msg];
            }
        }
    }];
}

-(void)playWithUrl:(NSString *)url andTitle:(NSString *)title{
    HJVideoPlayerController * videoC = [[HJVideoPlayerController alloc] init];
    [videoC.configModel setOnlyFullScreen:NO];
    [videoC.configModel setAutoPlay:NO];
    [videoC setUrl:url];
    [videoC setVideoTitle:title];
    self.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:videoC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
