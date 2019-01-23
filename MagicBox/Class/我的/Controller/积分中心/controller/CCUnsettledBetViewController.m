//
//  CCUnsettledBetViewController.m
//  SmallGames
//
//  Created by hello on 2018/9/23.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCUnsettledBetViewController.h"
#import "CCPointsTableViewCell.h"
#import "CCPointsModel.h"

@interface CCUnsettledBetViewController ()
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation CCUnsettledBetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initData];
}

-(void)initView{
    [super initView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.backgroundImageView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    self.backgroundImageView.image = nil;
    self.backgroundImageView.backgroundColor = MCUIColorFromRGB(0xF9F9F9);


    self.tableView.backgroundColor = [UIColor clearColor];

    [self.tableView registerClass:[CCPointsTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.backgroundImageView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.backgroundImageView).offset(65);
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CCPointsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.pointsModel = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}




#pragma 获取数据
-(void)initData{
    [CCView BSMBProgressHUD_bufferAndTextWithView:self.view andText:nil];
    [CCMineManage MineDownloadRecordWithCode:[AppDelegate sharedApplicationDelegate].userInfoModel.selfcode completion:^(id resultDictionary, NSError *error) {
        [CCView BSMBProgressHUD_hideWith:self.view];
        if (error) {
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"网络错误，请稍后再试！"];
            [self viewEmpty];
        }else{
            NSString *code = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"code"]];
            if ([code isEqualToString:@"1000"]) {
                NSArray *array = [resultDictionary objectForKey:@"data"];
                if (![array isKindOfClass:[NSNull class]]) {
                    for (int i = 0; i < array.count; i++) {
                        CCPointsModel *model = [CCPointsModel modelWithDictionary:[array objectAtIndex:i]];
                        [self.dataArray addObject:model];
                    }
                    [self.tableView reloadData];
                    if (self.dataArray.count == 0) {
                        [self viewEmpty];
                    }
                }
            }else{
                NSString *msg = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"msg"]];
                [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:msg];
                [self viewEmpty];
            }
        }
    }];
}

-(void)viewEmpty{
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableView);
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
