//
//  CCPasswordViewController.m
//  KitchenAlwaysOnline
//
//  Created by hello on 2018/9/13.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCPasswordViewController.h"
#import "CCUserInfoView.h"
#import "Masonry.h"
#import "CCMineManage.h"

@interface CCPasswordViewController ()<UITextFieldDelegate>{
    NSString *userPhone;
    NSTimer *_timer;     //定时器
    NSInteger _second;    //倒计时的时间
}
@property (nonatomic, strong) CCUserInfoView * userNameView;
@property (nonatomic, strong) CCUserInfoView * QRCodeView;
@property (nonatomic, strong) CCUserInfoView * passowordView;
@property (nonatomic, strong) CCUserInfoView * confirmView;

@property(nonatomic,strong)UIButton *codeButton;
@property(nonatomic,strong)UIButton *confirmButton;
@end

@implementation CCPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initView];
}

-(void)initView{
    [super initView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"安全隐私";
    self.navigationItem.leftBarButtonItem = self.customLeftItem;

    self.backgroundImageView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    self.backgroundImageView.image = nil;
    self.backgroundImageView.backgroundColor = MCUIColorFromRGB(0xF9F9F9);
    
    if ([self.viewTaye isEqualToString:@"1"]) {
        self.title = @"忘记密码";
        [self forgetPassword];
    }else{
        self.title = @"修改密码";
        [self changePassword];
    }
}

-(void)changePassword{
    self.userNameView.textField.placeholder = @"请输入旧密码";
    self.userNameView.textField.secureTextEntry = YES;
    [self.view addSubview:self.userNameView];
    [self.userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.top.equalTo(self.view).offset(80);
        make.height.mas_equalTo(50);
    }];
    
    self.passowordView.textField.placeholder = @"请输入新密码";
    [self.view addSubview:self.passowordView];
    [self.passowordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.top.equalTo(self.userNameView.mas_bottom);
        make.height.mas_equalTo(50);
    
    }];
    
    self.confirmView.textField.placeholder = @"请再次确认新密码";
    [self.view addSubview:self.confirmView];
    [self.confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.top.equalTo(self.passowordView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    [self.confirmButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.view addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.top.equalTo(self.confirmView.mas_bottom).offset(50);
        make.height.mas_equalTo(50);
    }];
}


-(void)forgetPassword{
    [self.view addSubview:self.userNameView];
    [self.userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view).with.offset(0);
        make.right.mas_equalTo(self.view).with.offset(0);
        make.top.mas_equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(60);
    }];
    
    
    [self.view addSubview:self.QRCodeView];
    [self.QRCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view).with.offset(0);
        make.right.mas_equalTo(self.view).with.offset(-120);
        make.top.mas_equalTo(self.userNameView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(60);
    }];
    
    
    [self.view addSubview:self.codeButton];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.view).with.offset(-10);
        make.bottom.mas_equalTo(self.QRCodeView);
        make.size.mas_equalTo(CGSizeMake(100, 44));
    }];
    
    [self.view addSubview:self.passowordView];
    [self.passowordView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view).with.offset(0);
        make.right.mas_equalTo(self.view).with.offset(0);
        make.top.mas_equalTo(self.QRCodeView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(60);
    }];
    
    [self.view addSubview:self.confirmView];
    [self.confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view).with.offset(0);
        make.right.mas_equalTo(self.view).with.offset(0);
        make.top.mas_equalTo(self.passowordView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(60);
    }];
    
    
    [self.view addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view).with.offset(10);
        make.right.mas_equalTo(self.view).with.offset(-10);
        make.top.mas_equalTo(self.confirmView.mas_bottom).offset(40);
        make.height.mas_equalTo(50);
    }];
}


- (CCUserInfoView *)userNameView {
    if (_userNameView == nil) {
        self.userNameView = [[CCUserInfoView alloc] init];
        self.userNameView.textField.placeholder = @"请输入您的手机号";
        self.userNameView.textField.delegate = self;
        self.userNameView.textField.keyboardType = UIKeyboardTypeASCIICapable;
        self.userNameView.textField.textColor = [UIColor blackColor];
        
    } return _userNameView;
}

- (CCUserInfoView *)QRCodeView {
    if (_QRCodeView == nil) {
        self.QRCodeView = [[CCUserInfoView alloc] init];
        self.QRCodeView.backgroundColor = [UIColor whiteColor];
        self.QRCodeView.textField.placeholder = @"请输入验证码";
        self.QRCodeView.textField.delegate = self;
        self.QRCodeView.textField.keyboardType = UIKeyboardTypeNumberPad;
        
    } return _QRCodeView;
}

- (CCUserInfoView *)passowordView {
    if (_passowordView == nil) {
        self.passowordView = [[CCUserInfoView alloc] init];
        self.passowordView.textField.placeholder = @"请输入新密码";
        self.passowordView.textField.delegate = self;
        self.passowordView.textField.keyboardType = UIKeyboardTypeASCIICapable;
        self.passowordView.textField.secureTextEntry = YES;
        self.passowordView.textField.textColor = [UIColor blackColor];
    } return _passowordView;
}

- (CCUserInfoView *)confirmView {
    if (_confirmView == nil) {
        self.confirmView = [[CCUserInfoView alloc] init];
        self.confirmView.textField.placeholder = @"请再次输入新密码";
        self.confirmView.textField.delegate = self;
        self.confirmView.textField.keyboardType = UIKeyboardTypeASCIICapable;
        self.confirmView.textField.secureTextEntry = YES;
        self.confirmView.textField.textColor = [UIColor blackColor];
    } return _confirmView;
}


- (UIButton *)codeButton {
    if (_codeButton == nil) {
        self.codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.codeButton.backgroundColor = [UIColor redColor];
        self.codeButton.layer.masksToBounds = YES;
        self.codeButton.layer.cornerRadius = 5;
        self.codeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.codeButton addTarget:self action:@selector(codeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    } return _codeButton;
}




- (UIButton *)confirmButton {
    if (_confirmButton == nil) {
        self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.confirmButton.backgroundColor = MCUIColorMain;
        self.confirmButton.layer.masksToBounds = YES;
        self.confirmButton.layer.cornerRadius = 25;
        self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:19];
        [self.confirmButton setTitle:@"确认找回" forState:UIControlStateNormal];
        [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    } return _confirmButton;
}

-(void)codeButtonClicked{
//    if (!self.userNameView.textField.text.length) {
//        [SVProgressHUD showInfoWithStatus:@"请输入手机号码！"];
//        return;
//    }
//    if (self.userNameView.textField.text.length != 11) {
//        [SVProgressHUD showInfoWithStatus:@"请输入正确的11位手机号码"];
//        return;
//    }
//
//    userPhone = self.userNameView.textField.text;
//    [CCMineManage MineGetVerificationCodeWithUserPhone:userPhone completion:^(id resultDictionary, NSError *error) {
//        if (error) {
//            [SVProgressHUD showErrorWithStatus:@"当前网络不好，请稍后再试！"];
//        }else{
//            NSString *msg = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"msg"]];
//            if (![msg isEqualToString:@"SUCCESS"]) {
//                NSString *msg = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"msg"]];
//                [SVProgressHUD showErrorWithStatus:msg];
//            }else{
//                [SVProgressHUD showInfoWithStatus:@"验证码已发送成功，请注意查收！"];
//                [self clickCodeButton];
//            }
//        }
//    }];
}

- (void)clickCodeButton{
    _second = 60;
    self.codeButton.enabled = NO;
    [self.QRCodeView.textField becomeFirstResponder];
    [self.codeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.codeButton setBackgroundColor:[UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1]];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
}

#pragma mark 定时器调用的方法
- (void)changeTime{
    _second --;
    [self.codeButton setTitle:[NSString stringWithFormat:@"%@ s",@(_second)] forState:UIControlStateNormal];
    if (_second == -1){
        [_timer invalidate];
        _timer = nil;
        self.codeButton.enabled = YES;
        [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.codeButton setBackgroundColor:[UIColor redColor]];
    }
}



-(void)confirmButtonClicked{
    if ([self.viewTaye isEqualToString:@"1"]) {
        [self forgetPasswordWithConfirmButtonClicked];
    }else{
        [self changePasswordWithConfirmButtonClicked];
    }
}

-(void)forgetPasswordWithConfirmButtonClicked{
//    if (!userPhone.length) {
//        [SVProgressHUD showInfoWithStatus:@"请先获取验证码"];
//        return;
//    }
//    if (!self.QRCodeView.textField.text.length) {
//        [SVProgressHUD showInfoWithStatus:@"请输入验证码"];
//        return;
//    }
//    if (!self.passowordView.textField.text.length) {
//        [SVProgressHUD showInfoWithStatus:@"请输入密码"];
//        return;
//    }
//    if (![self.passowordView.textField.text isEqualToString:self.confirmView.textField.text]) {
//        [SVProgressHUD showInfoWithStatus:@"输入的两次密码不一样"];
//        return;
//    }
//    [CCMineManage MineForgetPasswordWithUserPhone:userPhone andPassWord:self.passowordView.textField.text andCode:self.QRCodeView.textField.text completion:^(id resultDictionary, NSError *error) {
//        if (error) {
//            [SVProgressHUD showErrorWithStatus:@"当前网络不好，请稍后再试！"];
//        }else{
//            NSString *msg = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"msg"]];
//            if (![msg isEqualToString:@"SUCCESS"]) {
//                NSString *msg = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"msg"]];
//                [SVProgressHUD showErrorWithStatus:msg];
//            }else{
//                [SVProgressHUD showInfoWithStatus:@"恭喜您，您已找回您的账号！"];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (2 *(NSEC_PER_SEC))), dispatch_get_main_queue(), ^{
//                    [self.navigationController popViewControllerAnimated:YES];
//                });
//            }
//        }
//    }];
}

-(void)changePasswordWithConfirmButtonClicked{
    [self.view endEditing:YES];
    if (!self.userNameView.textField.text.length) {
        [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"请输入旧密码！"];
        return;
    }
    if (!self.passowordView.textField.text.length) {
        [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"请输入新密码！"];
        return;
    }
    if (!self.confirmView.textField.text.length) {
        [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"请再一次输入新密码！"];
        return;
    }
    if (![self.passowordView.textField.text isEqualToString:self.confirmView.textField.text]) {
        [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"输入的两次新密码不一样！"];
        return;
    }
    
    [CCView BSMBProgressHUD_bufferAndTextWithView:self.view andText:@"正在修改密码，请稍后！"];
    
    [CCMineManage MineChangepwdWithMobile:[AppDelegate sharedApplicationDelegate].userInfoModel.user_login andPassword:self.userNameView.textField.text andNewpassword:self.passowordView.textField.text completion:^(id resultDictionary, NSError *error) {
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
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
