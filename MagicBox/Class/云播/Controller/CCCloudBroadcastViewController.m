//
//  CCCloudBroadcastViewController.m
//  MagicBox
//
//  Created by hello on 2018/11/10.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCCloudBroadcastViewController.h"
#import "CCCloudBroadcastListViewController.h"
#import "CCBroadcastModel.h"
#import "CCPersonalCell.h"

@interface CCCloudBroadcastViewController ()
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation CCCloudBroadcastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
}


-(void)initView{
    self.navigationItem.leftBarButtonItem = self.customLeftItem;
    self.view.backgroundColor = MCUIColorFromRGB(0xe9e9e9);
    
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[CCPersonalCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
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
    
    CCBroadcastModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.cellTitle = model.uname;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CCCloudBroadcastListViewController *cblvc = [[CCCloudBroadcastListViewController alloc]init];
    cblvc.cloudBroadcastType = _cloudBroadcastType;
    cblvc.broadcastModel = [self.dataArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:cblvc animated:YES];
}

-(void)setCloudBroadcastType:(CloudBroadcastType)cloudBroadcastType{
    _cloudBroadcastType = cloudBroadcastType;
}

-(void)initData{
    [CCView BSMBProgressHUD_bufferAndTextWithView:self.view andText:nil];
    [CCMineManage MineCloudBroadcastWithCloudBroadcastType:_cloudBroadcastType Completion:^(id resultDictionary, NSError *error) {
        [CCView BSMBProgressHUD_hideWith:self.view];
        if (error) {
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"网络错误，请稍后再试！"];
        }else{
            NSArray *array = [resultDictionary objectForKey:@"data"];
            for (int i = 0; i < array.count; i++) {
                CCBroadcastModel *model = [CCBroadcastModel modelWithDictionary:[array objectAtIndex:i]];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
    }];
}



-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
