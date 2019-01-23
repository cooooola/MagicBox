//
//  CCMineSettingViewController.m
//  MusicHouse
//
//  Created by hello on 2018/10/10.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCMineSettingViewController.h"
#import "CCPasswordViewController.h"
#import "CCMineCell.h"


@interface CCMineSettingViewController ()
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)UIButton *signoutButton;
@end

@implementation CCMineSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[@"修改密码"];
}

-(void)initView{
    [super initView];
    self.title = @"设置";
    self.backgroundImageView.backgroundColor = MCUIColorFromRGB(0xf7f7f7);
    self.navigationItem.leftBarButtonItem = self.customLeftItem;
    
    [self.tableView registerClass:[CCMineCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = MCUIColorFromRGB(0xf7f7f7);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-100);
    }];
    
    [self.view addSubview:self.signoutButton];
    [self.signoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.view).offset(-30);
    }];
}

-(UIButton *)signoutButton{
    if (!_signoutButton) {
        _signoutButton = [[UIButton alloc]init];
        _signoutButton.layer.masksToBounds = YES;
        _signoutButton.layer.cornerRadius = 4;
        UIColor *color = MCUIColorRed;
        _signoutButton.layer.borderColor = color.CGColor;
        _signoutButton.layer.borderWidth = 1;
        [_signoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_signoutButton setTitleColor:MCUIColorRed forState:UIControlStateNormal];
        [_signoutButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_signoutButton addTarget:self action:@selector(clickSignoutButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signoutButton;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [self.dataArray objectAtIndex:section];
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CCMineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.cellTitle = [NSString stringWithFormat:@"%@",[self.dataArray objectAtIndex:indexPath.row]];
    cell.isHiddRightImg = NO;
//    if (indexPath.section == 0&&(indexPath.row == 1||indexPath.row == 2)) {
//        cell.isHiddRightImg = YES;
//    }else{
//        cell.isHiddRightImg = NO;
//    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CCPasswordViewController *pwvc = [[CCPasswordViewController alloc]init];
        pwvc.viewTaye = @"2";
        [self.navigationController pushViewController:pwvc animated:YES];
    }
}

-(nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 15)];
    return sectionHeaderView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}


-(void)clickSignoutButton{
    [CCUserInfoModel UserInfoRemove];
    [AppDelegate sharedApplicationDelegate].userInfoModel = nil;
    [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"您已退出登录，谢谢使用！"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (2 *(NSEC_PER_SEC))), dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
