//
//  CCWebFooterView.m
//  MagicBox
//
//  Created by hello on 2018/11/28.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCWebFooterView.h"

@interface CCWebFooterView()
@property(nonatomic,strong)UIButton *returnButton;
@property(nonatomic,strong)UIButton *playButton;
@end

@implementation CCWebFooterView

-(void)initView{
    [self setBackgroundColor:MCUIColorMain];
    [self addSubview:self.returnButton];
    [self.returnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(@40);
    }];
    
    [self addSubview:self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.bottom.equalTo(self).offset(-5);
        make.right.equalTo(self).offset(-10);
        make.width.equalTo(@60);
    }];
}

-(UIButton *)returnButton{
    if (!_returnButton) {
        _returnButton = [[UIButton alloc]init];
        [_returnButton setImage:[UIImage imageNamed:@"向左"] forState:UIControlStateNormal];
        [_returnButton addTarget:self action:@selector(clickReturnButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnButton;
}

-(UIButton *)playButton{
    if (!_playButton) {
        _playButton = [[UIButton alloc]init];
        _playButton.layer.borderWidth = 1;
        _playButton.layer.borderColor = [UIColor blackColor].CGColor;
        _playButton.layer.cornerRadius = 3;
        [_playButton setTitle:@"vip播放" forState:UIControlStateNormal];
        [_playButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(clickPlayButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

-(void)clickReturnButton{
    if (self.clickReturnBtn) {
        self.clickReturnBtn();
    }
}

-(void)clickPlayButton{
    [CCMineManage MineMemberInspectionCompletion:^(BOOL MemberStatus) {
        if (MemberStatus) {
            if (self.clickPlayBtn) {
                self.clickPlayBtn();
            }
        }
    }];
}

@end
