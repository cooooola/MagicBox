//
//  CCImageClassViewController.m
//  MagicBox
//
//  Created by hello on 2018/11/16.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCImageClassViewController.h"
#import "CCLivePlatformCollectionViewCell.h"
#import "CCCloudBroadcastListModel.h"
#import "YCPhotoBrowserAnimator.h"
#import "YCPhotoBrowserController.h"
#import "SDWebImageManager.h"
#import "CCJsonTool.h"

@interface CCImageClassViewController()<UICollectionViewDataSource,
UICollectionViewDelegate,
UIScrollViewDelegate>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger page;
@end

@implementation CCImageClassViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    _page = 1;
    [self initData];
}

-(void)initView{
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
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
            [self showAtlasWitthAtlasId:model.Id];
        }
    }];
//    [CCMineManage MineMemberInspectionCompletion:^(BOOL MemberStatus) {
//        if (MemberStatus) {
//            CCCloudBroadcastListModel *model = [self.dataArray objectAtIndex:indexPath.row];
//            [self showAtlasWitthAtlasId:model.Id];
//        }
//    }];
}

-(void)setBroadcastModel:(CCBroadcastModel *)broadcastModel{
    _broadcastModel = broadcastModel;
}

#pragma 请求图集列表
-(void)initData{
    if (self.dataArray.count == 0) {
       [CCView BSMBProgressHUD_bufferAndTextWithView:self.view andText:nil];
    }
    [CCMineManage MineImageListWithPage:[NSString stringWithFormat:@"%ld",(long)_page] andCid:_broadcastModel.uid completion:^(id resultDictionary, NSError *error) {
        [CCView BSMBProgressHUD_hideWith:self.view];
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        if (error) {
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"网络错误，请稍后再试！"];
        }else{
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            NSArray *array = [resultDictionary objectForKey:@"data"];
            for (int i = 0; i < array.count; i++) {
                CCCloudBroadcastListModel *model = [CCCloudBroadcastListModel modelWithDictionary:[array objectAtIndex:i]];
                [self.dataArray addObject:model];
            }
            if (array.count < 20) {
                [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.collectionView reloadData];
        }
    }];
}

#pragma 请求图集
-(void)showAtlasWitthAtlasId:(NSString *)atlasId{
    [CCView BSMBProgressHUD_bufferAndTextWithView:self.view andText:@"图集数据请求中，请稍候..."];
    [CCMineManage MineImageContentWithFictionId:atlasId completion:^(id resultDictionary, NSError *error) {
        [CCView BSMBProgressHUD_hideWith:self.view];
        if (error) {
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"网络错误，请稍后现试！"];
        }else{
            NSString *code = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"code"]];
            if ([code isEqualToString:@"1000"]) {
                NSDictionary *dic = [resultDictionary objectForKey:@"data"];
                NSString *imageUrlString = [dic objectForKey:@"jqimages"];
                NSArray *array = [imageUrlString componentsSeparatedByString:@","];
                if (array.count == 0) {
                    [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"未获取到图片，请稍后再试！"];
                }else{
                    [self showImageControllerWithArray:array];
                }
            }
        }
    }];
}

-(void)showImageControllerWithArray:(NSArray *)imageArray{
    YCPhotoBrowserController *vc = [YCPhotoBrowserController instanceWithShowImagesURLs:imageArray urlReplacing:nil];
    vc.indicatorType = YCIndicatorType_Number;
    vc.placeholder = [UIImage imageNamed:@"平台icon"];
    vc.indexPath = 0;
    vc.longPressBlock = ^(NSInteger celltag) {
        if ([CCJsonTool checkPhotoLibraryAuthorizationStatus]) {
            [self toSaveImage:[imageArray objectAtIndex:celltag]];
        }
    };
    vc.isShowSaveButton = NO;
    [self presentViewController:vc animated:YES completion:nil];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![@"YES" isEqualToString:[userDefaults objectForKey:@"isShowPhotoMassage"]]) {
        [userDefaults setObject:@"YES" forKey:@"isShowPhotoMassage"];
        [CCView BSMBProgressHUD_onlyTextWithView:[AppDelegate sharedApplicationDelegate].window andText:@"长按图片可以保存"];
    }
}

- (void)toSaveImage:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString: urlString];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    __block UIImage *img;
    [manager diskImageExistsForURL:url completion:^(BOOL isInCache) {
        if (isInCache) {
           img =  [[manager imageCache] imageFromDiskCacheForKey:url.absoluteString];
        }else{
            NSData *data = [NSData dataWithContentsOfURL:url];
            img = [UIImage imageWithData:data];
        }
        
        UIImageWriteToSavedPhotosAlbum(img,self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    }];
}
//保存图片完成之后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo{
    if (error != NULL){
        [CCView BSMBProgressHUD_onlyTextWithView:[AppDelegate sharedApplicationDelegate].window andText:@"图片保存失败"];
    }else{
        [CCView BSMBProgressHUD_onlyTextWithView:[AppDelegate sharedApplicationDelegate].window andText:@"图片保存成功"];
    }
}



-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



@end
