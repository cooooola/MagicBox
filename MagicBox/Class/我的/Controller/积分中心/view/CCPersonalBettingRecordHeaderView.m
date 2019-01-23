//
//  CCPersonalBettingRecordHeaderView.m
//  SmallGames
//
//  Created by hello on 2018/9/23.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCPersonalBettingRecordHeaderView.h"

@interface CCPersonalBettingRecordHeaderView()
@property(nonatomic,strong)UIButton *unsettledBetButton;
@property(nonatomic,strong)UIButton *bettingTodayButton;
@property(nonatomic,strong)UIView *viewline;
@end

@implementation CCPersonalBettingRecordHeaderView

-(void)initView{
    [super initView];
    
    self.backgroundColor = MCUIColorFromRGB(0xEEF4F9);
    
    [self addSubview:self.unsettledBetButton];
    [self.unsettledBetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.width.equalTo(@(MCScreenWidth/2));
        make.height.equalTo(@50);
    }];
    
    [self addSubview:self.bettingTodayButton];
    [self.bettingTodayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.width.equalTo(@(MCScreenWidth/2));
         make.height.equalTo(@50);
    }];
    
    [self addSubview:self.viewline];
    [self.viewline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-20);
        make.height.equalTo(@2);
        make.width.equalTo(@(MCScreenWidth/4));
        make.centerX.equalTo(self.unsettledBetButton);
        
    }];
}



- (UIButton *)unsettledBetButton {
    if (_unsettledBetButton == nil) {
        _unsettledBetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _unsettledBetButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_unsettledBetButton setBackgroundColor:[UIColor whiteColor]];
        [_unsettledBetButton setTitle:@"下载" forState:UIControlStateNormal];
        _unsettledBetButton.selected = YES;
        [_unsettledBetButton setTitleColor:MCUIColorFromRGB(0x64A0D7) forState:UIControlStateSelected];
        [_unsettledBetButton setTitleColor:MCUIColorFromRGB(0x777777) forState:UIControlStateNormal];
        [_unsettledBetButton addTarget:self action:@selector(clickUnsettledBetButton:) forControlEvents:UIControlEventTouchUpInside];
    } return _unsettledBetButton;
}

- (UIButton *)bettingTodayButton {
    if (_bettingTodayButton == nil) {
        _bettingTodayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bettingTodayButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_bettingTodayButton setTitle:@"注册" forState:UIControlStateNormal];
        _bettingTodayButton.selected = NO;
        [_bettingTodayButton setBackgroundColor:[UIColor whiteColor]];
        [_bettingTodayButton setTitleColor:MCUIColorFromRGB(0x64A0D7) forState:UIControlStateSelected];
        [_bettingTodayButton setTitleColor:MCUIColorFromRGB(0x777777) forState:UIControlStateNormal];
        [_bettingTodayButton addTarget:self action:@selector(clickBettingTodayButton:) forControlEvents:UIControlEventTouchUpInside];
    } return _bettingTodayButton;
}

-(UIView *)viewline{
    if (!_viewline) {
        _viewline = [[UIView alloc]init];
        _viewline.backgroundColor = MCUIColorFromRGB(0x64A0D7);
    }
    return _viewline;
}

-(void)clickUnsettledBetButton:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    sender.selected = !sender.selected;
    self.bettingTodayButton.selected = !sender.selected;
    [self.viewline mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-20);
        make.height.equalTo(@2);
        make.width.equalTo(@(MCScreenWidth/4));
        make.centerX.equalTo(self.unsettledBetButton);
    }];
    
    if (self.unsettledBetBtn) {
        self.unsettledBetBtn();
    }
    
}

-(void)clickBettingTodayButton:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    sender.selected = !sender.selected;
    self.unsettledBetButton.selected = !sender.selected;
    [self.viewline mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-20);
        make.height.equalTo(@2);
        make.width.equalTo(@(MCScreenWidth/4));
        make.centerX.equalTo(self.bettingTodayButton);
    }];
    
    if (self.bettingTodayBtn) {
        self.bettingTodayBtn();
    }
}

@end
