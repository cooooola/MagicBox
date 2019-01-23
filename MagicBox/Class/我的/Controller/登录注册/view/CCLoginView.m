//
//  CCLoginView.m
//  SmallGames
//
//  Created by hello on 2018/9/19.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCLoginView.h"

static float VIEWW = 70;

@interface CCLoginView()<UITextFieldDelegate>{
    NSString *userPhone;
    NSTimer *_timer;     //定时器
    NSInteger _second;    //倒计时的时间
}
@property(nonatomic,strong)UIButton *codeButton;
@end

@implementation CCLoginView

-(void)initView{
    [super initView];
    [self addSubview:self.userNameView];
    [self.userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).with.offset(0);
        make.right.mas_equalTo(self).with.offset(0);
        make.top.mas_equalTo(self).with.offset(0);
        make.height.mas_equalTo(VIEWW);
    }];
    

    
    [self addSubview:self.passwordView];
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).with.offset(0);
        make.right.mas_equalTo(self).with.offset(0);
        make.top.mas_equalTo(self.userNameView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(VIEWW);
    }];
    
    [self addSubview:self.confirmView];
    [self.confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).with.offset(0);
        make.right.mas_equalTo(self).with.offset(0);
        make.top.mas_equalTo(self.passwordView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(VIEWW);
    }];
    
    [self addSubview:self.codeView];
    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).with.offset(0);
        make.right.mas_equalTo(self).with.offset(0);
        make.top.mas_equalTo(self.confirmView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(VIEWW);
    }];
    
    [self.codeView addSubview:self.codeButton];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.codeView);
        make.height.equalTo(@(VIEWW));
        make.width.equalTo(@120);
    }];
    
    self.codeView.textField.rightView = self.verificationCodeView;
    
    
    [self addSubview:self.referrerView];
    [self.referrerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).with.offset(0);
        make.right.mas_equalTo(self).with.offset(0);
        make.top.mas_equalTo(self.codeView.mas_bottom).with.offset(0);
        make.height.mas_equalTo(VIEWW);
    }];
    
}

- (CCUserInfoView *)userNameView {
    if (_userNameView == nil) {
        _userNameView = [[CCUserInfoView alloc] init];
        _userNameView.textField.placeholder = @"请手机号码";
        _userNameView.textField.delegate = self;
        [_userNameView.textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        _userNameView.textField.keyboardType = UIKeyboardTypeASCIICapable;
        _userNameView.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _userNameView.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    } return _userNameView;
}

- (CCUserInfoView *)passwordView {
    if (_passwordView == nil) {
        _passwordView = [[CCUserInfoView alloc] init];
        _passwordView.textField.placeholder = @"请输入密码";
        _passwordView.textField.secureTextEntry = YES;
        _passwordView.textField.delegate = self;
        [_passwordView.textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        _passwordView.textField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordView.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordView.textField.secureTextEntry = YES;
        _passwordView.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        
    } return _passwordView;
}

- (CCUserInfoView *)confirmView {
    if (_confirmView == nil) {
        _confirmView = [[CCUserInfoView alloc] init];
        _confirmView.textField.placeholder = @"请再次输入密码";
        _confirmView.textField.delegate = self;
        _confirmView.textField.keyboardType = UIKeyboardTypeASCIICapable;
        _confirmView.textField.secureTextEntry = YES;
        [_confirmView.textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        _confirmView.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _confirmView.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    } return _confirmView;
}

- (CCUserInfoView *)codeView {
    if (_codeView == nil) {
        _codeView = [[CCUserInfoView alloc] init];
        _codeView.textField.placeholder = @"请输入验证码";
        _codeView.textField.delegate = self;
        _codeView.textField.keyboardType = UIKeyboardTypeASCIICapable;
        [_codeView.textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        _codeView.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _codeView.textField.autocorrectionType = UITextAutocorrectionTypeNo;
        _codeView.textField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _codeView;
}

- (UIButton *)codeButton{
    if (_codeButton == nil) {
        _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeButton setTitleColor:MCUIColorMain forState:UIControlStateNormal];
        [_codeButton addTarget:self action:@selector(codeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    } return _codeButton;
}

- (CCUserInfoView *)referrerView {
    if (_referrerView == nil) {
        _referrerView = [[CCUserInfoView alloc] init];
        _referrerView.textField.placeholder = @"请输入推荐码";
        _referrerView.textField.delegate = self;
        [_referrerView.textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        _referrerView.textField.keyboardType = UIKeyboardTypeASCIICapable;
        _referrerView.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _referrerView.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    return _referrerView;
}


-(CCVerificationCodeView *)verificationCodeView{
    if (!_verificationCodeView) {
        _verificationCodeView = [[CCVerificationCodeView alloc]init];
    }
    return _verificationCodeView;
}

-(void)codeButtonClicked{
    if (!self.userNameView.textField.text.length) {
        [CCView BSMBProgressHUD_onlyTextWithView:self andText:@"请输入手机号码！"];
        return;
    }
    if (self.userNameView.textField.text.length != 11) {
        [CCView BSMBProgressHUD_onlyTextWithView:self andText:@"请输入正确的11位手机号码"];
        return;
    }
    
    userPhone = self.userNameView.textField.text;
    [CCView BSMBProgressHUD_bufferAndTextWithView:self andText:@"验证码发送中，请稍候..."];
    [CCMineManage MineVerificationCodeWithMobile:self.userNameView.textField.text completion:^(id resultDictionary, NSError *error) {
        [CCView BSMBProgressHUD_hideWith:self];
        if (error) {
            [CCView BSMBProgressHUD_onlyTextWithView:self andText:@"网络错误，请稍后再试！"];
        }else{
            NSString *result = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"result"]];
            if ([result isEqualToString:@"1000"]) {
                [CCView BSMBProgressHUD_onlyTextWithView:self andText:@"验证码已发送成功，请注意查收！"];
                [self clickCodeButton];
            }else{
                NSString *msg = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"msg"]];
                [CCView BSMBProgressHUD_onlyTextWithView:self andText:msg];
            }
        }
    }];
}

- (void)clickCodeButton{
    _second = 60;
    self.codeButton.enabled = NO;
    [self.codeView.textField becomeFirstResponder];
    [self.codeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
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
        [self.codeButton setTitleColor:MCUIColorMain forState:UIControlStateNormal];
    }
}


@end
