//
//  CCEroticNovelClassViewController.m
//  MagicBox
//
//  Created by hello on 2018/11/16.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCEroticNovelClassViewController.h"
#import "CCCloudBroadcastListModel.h"
#import "CCPersonalCell.h"

#import "CCEroticNovelWebViewController.h"

@interface CCEroticNovelClassViewController()
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)NSInteger page;
@end

@implementation CCEroticNovelClassViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    _page = 1;
    [self initData];
}

-(void)initView{

    
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[CCPersonalCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->_page = 1;
        [self initData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page ++;
        [self initData];
    }];
}

-(void)setBroadcastModel:(CCBroadcastModel *)broadcastModel{
    _broadcastModel = broadcastModel;
}

-(void)initData{
    if (self.dataArray.count == 0) {
        [CCView BSMBProgressHUD_bufferAndTextWithView:self.view andText:nil];
    }
    [CCMineManage MineFictionListWithPage:[NSString stringWithFormat:@"%ld",(long)_page] andCid:_broadcastModel.uid completion:^(id resultDictionary, NSError *error) {
        [CCView BSMBProgressHUD_hideWith:self.view];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (error) {
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"网络错误，请稍后再试！"];
        }else{
            NSArray *array = [resultDictionary objectForKey:@"data"];
            if (array.count < 20) {
               [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            for (int i = 0; i < array.count; i++) {
                CCCloudBroadcastListModel *model = [CCCloudBroadcastListModel modelWithDictionary:[array objectAtIndex:i]];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CCPersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    CCCloudBroadcastListModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.cellTitle = model.title;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [CCMineManage MineMemberInspectionWithViewController:self Completion:^(BOOL MemberStatus) {
        if (MemberStatus) {
            CCEroticNovelWebViewController *enwvc = [[CCEroticNovelWebViewController alloc]init];
            enwvc.cloudBroadcastListModel = [self.dataArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:enwvc animated:YES];
        }
    }];
//    [CCMineManage MineMemberInspectionCompletion:^(BOOL MemberStatus) {
//        if (MemberStatus) {
//            CCEroticNovelWebViewController *enwvc = [[CCEroticNovelWebViewController alloc]init];
//            enwvc.cloudBroadcastListModel = [self.dataArray objectAtIndex:indexPath.row];
//            [self.navigationController pushViewController:enwvc animated:YES];
//        }
//    }];
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
