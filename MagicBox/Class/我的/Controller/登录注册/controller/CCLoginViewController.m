//
//  CCLoginViewController.m
//  KitchenAlwaysOnline
//
//  Created by hello on 2018/9/13.
//  Copyright © 2018年 hello. All rights reserved.
//

#define MCScreenWidth [UIScreen mainScreen].bounds.size.width

#import "CCLoginViewController.h"
#import "CCLoginView.h"
#import "CCRegisteredViewController.h"//注册
#import "CCUserInfoModel.h"
#import "CCAppSettingManager.h"


@interface CCLoginViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)CCLoginView *loginView;
@property(nonatomic, strong)UIButton *loginButton;
@property(nonatomic, strong)UIButton *registerButton;
@property(nonatomic,strong)UIImageView *logoImageView;
@end

@implementation CCLoginViewController

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
}



-(void)initView{
    [super initView];
    
    self.backgroundImageView.image = [UIImage imageNamed:@"登录背景"];
    
    [self.view addSubview:self.returnBurron];
    [self.returnBurron mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(MCStatusBarHeight+5);
        make.left.equalTo(self.view).offset(10);
        make.width.height.equalTo(@40);
    }];
    
    [self.view addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(MCStatusBarHeight+10);
        make.centerX.equalTo(self.view);
    }];
    
    
    [self.view addSubview:self.loginView];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(MCScreenWidth-40));
        make.height.equalTo(@140);
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-30);
    }];
    
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginView.mas_bottom).offset(80);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@50);
    }];
    
    [self.view addSubview:self.registerButton];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@50);
    }];
    
}



- (UIButton *)registerButton {
    if (_registerButton == nil) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.layer.masksToBounds = YES;
        _registerButton.layer.cornerRadius = 5;
        [_registerButton setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(registerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    } return _registerButton;
}

- (UIButton *)loginButton {
    if (_loginButton == nil) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setBackgroundColor:MCUIColorMain];
        _loginButton.layer.masksToBounds = YES;
        _loginButton.layer.cornerRadius = 5;
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(clickLoginButton) forControlEvents:UIControlEventTouchUpInside];
    } return _loginButton;
}



-(UIImageView *)logoImageView{
    if (_logoImageView == nil) {
        _logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"注册-顶部LOGO"]];
    }
    return _logoImageView;
}


-(void)registerButtonClicked{
    CCRegisteredViewController *registeredVC = [[CCRegisteredViewController alloc]init];
    [self.navigationController pushViewController:registeredVC animated:YES];
}

//登陆
-(void)clickLoginButton{
    [self.loginView.userNameView.textField resignFirstResponder];
    [self.loginView.passwordView.textField resignFirstResponder];
    
    if (self.loginView.userNameView.textField.text.length == 0) {
        [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"请输入手机号码"];
        return;
    }
    if (self.loginView.passwordView.textField.text.length == 0) {
        [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"请输入密码"];
        return;
    }
    
    [CCView BSMBProgressHUD_bufferAndTextWithView:self.view andText:@"正在登录，请稍等！"];
    [CCMineManage MineLoginWithMobile:self.loginView.userNameView.textField.text andPassword:self.loginView.passwordView.textField.text completion:^(id resultDictionary, NSError *error) {
        [CCView BSMBProgressHUD_hideWith:self.view];
        if (error) {
           [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"网络错误，请稍后再试！"];
        }else{
            NSString *result = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"result"]];
            NSString *msg = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"msg"]];
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:msg];
            if ([result isEqualToString:@"1000"]) {
                NSString *uname = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"uname"]];
                [self getUserInformationWithMobile:uname];
            }
        }
    }];
}

-(CCLoginView *)loginView{
    if (!_loginView) {
        _loginView = [[CCLoginView alloc]init];
        _loginView.layer.masksToBounds = YES;
        _loginView.layer.cornerRadius = 5;
        _loginView.backgroundColor = [UIColor clearColor];
    }
    return _loginView;
}

#pragma 获取用户信息
-(void)getUserInformationWithMobile:(NSString *)mobile{
    [CCView BSMBProgressHUD_bufferAndTextWithView:self.view andText:@"用户信息获取中，请稍等！"];
    [CCMineManage MineUserInfoWithMobile:mobile completion:^(id resultDictionary, NSError *error) {
        [CCView BSMBProgressHUD_hideWith:self.view];
        if (error) {
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"网络错误，请稍后再试！"];
        }else{
            NSString *result = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"result"]];
            if ([result isEqualToString:@"1000"]) {
               [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"已获取成功，欢迎使用大黄鸭！"];
                NSDictionary *userInfoDic = [resultDictionary objectForKey:@"data"];
                [CCUserInfoModel UserInfoStorageWithObject:userInfoDic];
                [AppDelegate sharedApplicationDelegate].userInfoModel = [CCUserInfoModel modelWithDictionary:userInfoDic];
                
                [CCAppSettingManager userStartSignIn];
                __block typeof(self) weakSelf = self;
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5* NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController  popViewControllerAnimated:YES];
                });
            }else{
                NSString *msg = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"msg"]];
                [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:msg];
            }
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
