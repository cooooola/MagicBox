//
//  CCMineViewController.m
//  MagicBox
//
//  Created by hello on 2018/11/2.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCMineViewController.h"
#import "CCPersonalHomeCell.h"
#import "CCMineHeaderView.h"

#import "CCMineMemberRrenewalViewController.h"
#import "CCLoginViewController.h"
#import "CCMineSettingViewController.h"
#import "CCMineProxyViewController.h"
#import "CCCleanCacheManager.h"
#import "CCMinePointsCenterViewController.h"
#import "CCPasswordViewController.h"
#import "CCWebViewController.h"

#import <AdSupport/ASIdentifierManager.h>

@interface CCMineViewController ()
@property(nonatomic,strong)CCMineHeaderView *mineHeaderView;
@property(nonatomic,strong)UIButton *SettingButton;
@property(nonatomic,strong)UIButton *signoutButton;
@property(nonatomic,strong)NSArray *dataArray;
@end

@implementation CCMineViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if ([AppDelegate sharedApplicationDelegate].userInfoModel) {
        [self getUserInfo];
        if ([AppDelegate sharedApplicationDelegate].fileConfigurationModel.sites.qq.length == 0) {
            self.dataArray = @[@"会员续费",@"活动中心",@"积分中心",@"清理缓存",@"修改密码"];
        }else{
            self.dataArray = @[@"会员续费",@"活动中心",@"积分中心",@"清理缓存",@"修改密码",@"客服QQ"];
        }
        
        _SettingButton.hidden = NO;
        self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
        [self.tableView.tableFooterView addSubview:self.signoutButton];
        [self.signoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.tableView.tableFooterView);
            make.height.equalTo(@40);
            make.width.width.equalTo(@(MCScreenWidth-40));
            make.bottom.equalTo(self.tableView.tableFooterView);
        }];
    }else{
        
        self.mineHeaderView.userInfoModel = [AppDelegate sharedApplicationDelegate].userInfoModel;
        if ([AppDelegate sharedApplicationDelegate].fileConfigurationModel.sites.qq.length == 0) {
            self.dataArray = @[@"会员续费",@"积分中心",@"清理缓存"];
        }else{
            self.dataArray = @[@"会员续费",@"活动中心",@"积分中心",@"清理缓存",@"客服QQ"];
        }
        _SettingButton.hidden = YES;
        self.tableView.tableFooterView = [[UIView alloc]init];
    }

    [self.tableView reloadData];
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)initView{
    self.view.backgroundColor = MCUIColorFromRGB(0xe9eff0);
    [self.view addSubview:self.mineHeaderView];
    [self.mineHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(MCStatusBarHeight+225));
    }];
    
    [self.tableView registerClass:[CCPersonalHomeCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.mineHeaderView.mas_bottom).offset(10);
    }];
    
//    [self.view addSubview:self.SettingButton];
//    [self.SettingButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset((MCStatusBarHeight+10));
//        make.right.equalTo(self.view).offset(-10);
//        make.width.height.equalTo(@40);
//    }];
}

-(CCMineHeaderView *)mineHeaderView{
    if (!_mineHeaderView) {
        _mineHeaderView = [[CCMineHeaderView alloc]init];
        __block typeof(self) weakself = self;
        _mineHeaderView.loginBtn = ^{
            [weakself userLogin];
        };
    }
    return _mineHeaderView;
}

-(UIButton *)SettingButton{
    if (!_SettingButton) {
        _SettingButton = [[UIButton alloc]init];
        [_SettingButton setImage:[UIImage imageNamed:@"账户设置"] forState:UIControlStateNormal];
        [_SettingButton addTarget:self action:@selector(clickSettingButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _SettingButton;
}

-(UIButton *)signoutButton{
    if (!_signoutButton) {
        _signoutButton = [[UIButton alloc]init];
        _signoutButton.layer.masksToBounds = YES;
        _signoutButton.layer.cornerRadius = 4;
//        UIColor *color = MCUIColorRed;
//        _signoutButton.layer.borderColor = color.CGColor;
//        _signoutButton.layer.borderWidth = 1;
        [_signoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_signoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_signoutButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_signoutButton setBackgroundImage:[UIImage imageWithColor:MCUIColorMain] forState:UIControlStateNormal];
        [_signoutButton addTarget:self action:@selector(clickSignoutButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signoutButton;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CCPersonalHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.cellImageName = [NSString stringWithFormat:@"%@",[self.dataArray objectAtIndex:indexPath.row]];
    cell.cellTitle = [NSString stringWithFormat:@"%@",[self.dataArray objectAtIndex:indexPath.row]];
    if ([[NSString stringWithFormat:@"%@",[self.dataArray objectAtIndex:indexPath.row]] isEqualToString:@"清理缓存"]) {
         cell.cellSubtitle = [NSString stringWithFormat:@"%.2f M",[CCCleanCacheManager folderSizeAtPath]];
    }else if ([[NSString stringWithFormat:@"%@",[self.dataArray objectAtIndex:indexPath.row]] isEqualToString:@"客服QQ"]) {
        cell.cellSubtitle = [AppDelegate sharedApplicationDelegate].fileConfigurationModel.sites.qq;
    }else{
        cell.cellSubtitle = nil;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![AppDelegate sharedApplicationDelegate].userInfoModel) {
        [self userLogin];return;
    }
    switch (indexPath.row) {
        case 0:{
            CCMineMemberRrenewalViewController *mmrvc = [[CCMineMemberRrenewalViewController alloc]init];
            [self.navigationController pushViewController:mmrvc animated:YES];
        }break;
        case 1:{
            if ([AppDelegate sharedApplicationDelegate].fileConfigurationModel.sites.site.length == 0) {
                [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"活动当前未开放"];
                return;
            }
            CCWebViewController *wvc = [[CCWebViewController alloc]init];
            wvc.webViewType = WebViewTypeNome;
            wvc.urlString = [NSString stringWithFormat:@"%@%@",[AppDelegate sharedApplicationDelegate].fileConfigurationModel.sites.site,[AppDelegate sharedApplicationDelegate].userInfoModel.Id];
            wvc.titleString = @"活动中心";
            [self.navigationController pushViewController:wvc animated:YES];
        }break;
        case 2:{
            CCMinePointsCenterViewController *mpcvc = [[CCMinePointsCenterViewController alloc]init];
            [self.navigationController pushViewController:mpcvc animated:YES];
        }break;
        case 3:{
            [CCView BSMBProgressHUD_bufferAndTextWithView:self.view andText:@"正在清理中..."];
            [CCCleanCacheManager cleanCache:^{
                [CCView BSMBProgressHUD_hideWith:self.view];
                [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"清理完成"];
                [self.tableView reloadData];
            }];
        }break;
        case 4:{
            CCPasswordViewController *pwvc = [[CCPasswordViewController alloc]init];
            pwvc.viewTaye = @"2";
            [self.navigationController pushViewController:pwvc animated:YES];
        }break;
        case 5:{
            if ([AppDelegate sharedApplicationDelegate].fileConfigurationModel.sites.qq.length == 0) {
                [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"客服当前未在钱"];
                return;
            }
            UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
            pastboard.string = [AppDelegate sharedApplicationDelegate].fileConfigurationModel.sites.qq;
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"已复制"];
        }break;
        default:
            break;
    }
}

#pragma 设置
-(void)clickSettingButton{
    CCMineSettingViewController *msvc = [[CCMineSettingViewController alloc]init];
    [self.navigationController pushViewController:msvc animated:YES];
}

#pragma 登陆
-(void)userLogin{
    CCLoginViewController *lvc = [[CCLoginViewController alloc]init];
    [self.navigationController pushViewController:lvc animated:YES];
}

#pragma 退出登陆
-(void)clickSignoutButton{
    [CCUserInfoModel UserInfoRemove];
    [AppDelegate sharedApplicationDelegate].userInfoModel = nil;
    [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"您已退出登录，谢谢使用！"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (2 *(NSEC_PER_SEC))), dispatch_get_main_queue(), ^{
        [self viewWillAppear:YES];
    });
}


//获取用户信息
-(void)getUserInfo{
    [CCMineManage MineUserInfoWithMobile:[AppDelegate sharedApplicationDelegate].userInfoModel.user_login completion:^(id resultDictionary, NSError *error) {
        if (!error) {
            NSString *result = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"result"]];
            if ([result isEqualToString:@"1000"]) {
                NSDictionary *userInfoDic = [resultDictionary objectForKey:@"data"];
                [CCUserInfoModel UserInfoStorageWithObject:userInfoDic];
                [AppDelegate sharedApplicationDelegate].userInfoModel = [CCUserInfoModel modelWithDictionary:userInfoDic];
                self.mineHeaderView.userInfoModel = [CCUserInfoModel modelWithDictionary:userInfoDic];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
