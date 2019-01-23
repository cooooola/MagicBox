//
//  CCRegisteredViewController.m
//  KitchenAlwaysOnline
//
//  Created by hello on 2018/9/13.
//  Copyright © 2018年 hello. All rights reserved.
//

#define MCScreenWidth [UIScreen mainScreen].bounds.size.width

#import "CCRegisteredViewController.h"
#import "CCLoginView.h"
#import "Masonry.h"
#import "CCMineManage.h"


@interface CCRegisteredViewController ()
@property(nonatomic,strong)CCLoginView *loginView;
@property(nonatomic,strong)UIButton *registerButton;
@property(strong,nonatomic)UIImageView *logoImageView;


@end

@implementation CCRegisteredViewController

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
    // Do any additional setup after loading the view.
    
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
        make.height.equalTo(@350);
        make.center.equalTo(self.view);
    }];
    
    [self.view addSubview:self.registerButton];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginView.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@50);
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

- (UIButton *)registerButton {
    if (_registerButton == nil) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerButton setBackgroundColor:MCUIColorMain];
        _registerButton.layer.masksToBounds = YES;
        _registerButton.layer.cornerRadius = 5;
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerButton addTarget:self action:@selector(clickRegisterButton) forControlEvents:UIControlEventTouchUpInside];
    } return _registerButton;
}


-(UIImageView *)logoImageView{
    if (_logoImageView == nil) {
        _logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"注册-顶部LOGO"]];
    }
    return _logoImageView;
}



//注册
-(void)clickRegisterButton{
    if (self.loginView.userNameView.textField.text.length == 0) {
        [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"请输入手机号码"];
        return;
    }
    if (self.loginView.passwordView.textField.text.length == 0) {
        [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"请输入密码"];
        return;
    }
    if (self.loginView.confirmView.textField.text.length == 0) {
        [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"请再一次输入密码"];
        return;
    }
    if (![self.loginView.passwordView.textField.text isEqualToString:self.loginView.confirmView.textField.text]) {
        [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"两次输入的密码不一致，请重新输入"];
        return;
    }
    
    if (self.loginView.codeView.textField.text.length == 0) {
        [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"请输入验证码"];
        return;
    }
//    if (self.loginView.referrerView.textField.text.length == 0) {
//        [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"请推荐码"];
//        return;
//    }
    
    [CCView BSMBProgressHUD_bufferAndTextWithView:self.view andText:@"正在注册，请稍等！"];
    [CCMineManage MineRegisterWithIvcode:self.loginView.referrerView.textField.text andMobile:self.loginView.userNameView.textField.text andVcode:self.loginView.codeView.textField.text andPassword:self.loginView.passwordView.textField.text completion:^(id resultDictionary, NSError *error) {
        [CCView BSMBProgressHUD_hideWith:self.view];
        if (error) {
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"网络错误，请稍后再试！"];
        }else{
            NSString *result = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"result"]];
            NSString *msg = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"msg"]];
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:msg];
            if ([result isEqualToString:@"1000"]) {
                __block typeof(self) weakSelf = self;
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5* NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController  popViewControllerAnimated:YES];
                });
            }
        }
    }];
}

//返回
-(void)clickReturnButton{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
