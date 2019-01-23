//
//  CCMineHeaderView.m
//  MagicBox
//
//  Created by hello on 2018/11/5.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCMineHeaderView.h"

@interface CCMineHeaderView()
@property(nonatomic,strong)UIImageView *imageview;
@property(nonatomic,strong)UIView *timeView;
@property(nonatomic,strong)UIImageView *timeImageView;
@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *userIdLabel;
@property(nonatomic,strong)UIImageView *headerImageView;

@property(nonatomic,strong)UIButton *loginButton;

@end

@implementation CCMineHeaderView

-(void)initView{
    [self addSubview:self.imageview];
    [self.imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.timeView];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-15);
        make.height.equalTo(@24);
        make.width.equalTo(@(MCScreenWidth/2));
        make.centerX.equalTo(self);
    }];
    
    [self.timeView addSubview:self.timeImageView];
    [self.timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeView);
        make.left.equalTo(self.timeView).offset(12);
    }];
    [self.timeView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeImageView.mas_right).offset(5);
        make.right.equalTo(self.timeView).offset(-5);
        make.centerY.equalTo(self.timeView);
    }];
    
    
    
    [self addSubview:self.headerImageView];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(MCStatusBarHeight+20));
        make.width.height.equalTo(@90);
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView.mas_bottom).offset(30);
        make.centerX.equalTo(self);
        make.height.equalTo(@30);
        make.width.equalTo(@120);
    }];
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView.mas_bottom).offset(15);
        make.centerX.equalTo(self);
        make.height.equalTo(@15);
    }];
    
    [self addSubview:self.userIdLabel];
    [self.userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self);
        make.height.equalTo(@15);
    }];
}

-(void)setUserInfoModel:(CCUserInfoModel *)userInfoModel{
    _userInfoModel = userInfoModel;
    if (userInfoModel) {
        self.loginButton.hidden = YES;
        self.nameLabel.hidden = NO;
        self.timeView.hidden = NO;
        self.userIdLabel.hidden = NO;
        self.nameLabel.text = userInfoModel.user_nicename;
        self.userIdLabel.text = [NSString stringWithFormat:@"用户ID:%@",userInfoModel.Id];
        self.timeLabel.text = [NSString stringWithFormat:@"会员到期:%@",userInfoModel.member_validity];
    }else{
        self.loginButton.hidden = NO;
        self.nameLabel.hidden = YES;
        self.timeView.hidden = YES;
        self.userIdLabel.hidden = YES;
    }
}

-(UIImageView *)imageview{
    if (!_imageview) {
        _imageview = [[UIImageView alloc]init];
        _imageview.image = [UIImage imageNamed:@"个人中心背景"];
    }
    return _imageview;
}

-(UIView *)timeView{
    if (!_timeView) {
        _timeView = [[UIView alloc]init];
        _timeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _timeView.layer.cornerRadius = 12;
        _timeView.layer.masksToBounds = YES;
        _timeView.hidden = YES;
    }
    return _timeView;
}

-(UIImageView *)timeImageView{
    if (!_timeImageView) {
        _timeImageView = [[UIImageView alloc]init];
        _timeImageView.image = [UIImage imageNamed:@"会员"];
    }
    return _timeImageView;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"2018年11月1日-2018年11月3日";
        _timeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _timeLabel;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.text = @"我的名字叫李三";
        _nameLabel.hidden = YES;
    }
    return _nameLabel;
}

-(UILabel *)userIdLabel{
    if (!_userIdLabel) {
        _userIdLabel = [[UILabel alloc]init];
        _userIdLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _userIdLabel.font = [UIFont systemFontOfSize:16];
        _userIdLabel.textAlignment = NSTextAlignmentCenter;
        _userIdLabel.text = @"用户ID";
        _userIdLabel.hidden = YES;
    }
    return _userIdLabel;
}

-(UIImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc]init];
        _headerImageView.image = [UIImage imageNamed:@"我的头像"];
        _headerImageView.layer.cornerRadius = 45;
        _headerImageView.layer.masksToBounds = YES;
    }
    return _headerImageView;
}

-(UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [[UIButton alloc]init];
        _loginButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _loginButton.layer.cornerRadius = 15;
        _loginButton.layer.masksToBounds = YES;
        [_loginButton setTitle:@"登录/注册" forState:UIControlStateNormal];
        [_loginButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_loginButton addTarget:self action:@selector(clickLoginButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

-(void)clickLoginButton{
    if (self.loginBtn) {
        self.loginBtn();
    }
}

@end
