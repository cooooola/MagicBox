//
//  CCPlayerView.m
//  MagicBox
//
//  Created by cola on 2019/1/23.
//  Copyright © 2019年 hello. All rights reserved.
//

#import "CCPlayerView.h"
#import "CCPlayOperatingView.h"


@interface CCPlayerView()<PLPlayerDelegate>
@property(nonatomic,strong)PLPlayerOption *option;
@property(nonatomic,strong)CCPlayOperatingView *playOperatingView;

@property(nonatomic,strong)UIView *userView;
@property(nonatomic,strong)UIImageView *userImageView;
@property(nonatomic,strong)UILabel *userNameLabel;
@end

@implementation CCPlayerView
-(void)initView{
    [self setOption];
//    [self addSubview:self.player.playerView];
    [self.player.playerView addSubview:self.playOperatingView];
    [self.playOperatingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.player.playerView);
    }];
    
//    [self addSubview:self.userView];
//    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(20);
//        make.top.equalTo(self).offset(MCStatusBarHeight+5);
//        make.height.equalTo(@30);
//        make.width.equalTo(@100);
//    }];
//
////    [self addSubview: self.adImageView];
////    [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(self.userView.mas_bottom).offset(10);
////        make.left.equalTo(self.userView);
////        make.height.equalTo(@40);
////        make.width.equalTo(@100);
////    }];
////
////    [self addSubview:self.adButton];
////    [self.adButton mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.edges.equalTo(self.adImageView);
////    }];
//
//    [self.userView addSubview:self.userImageView];
//    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.bottom.equalTo(self.userView);
//        make.width.equalTo(@30);
//    }];
//    [self.userView addSubview:self.userNameLabel];
//    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.userImageView.mas_right).offset(5);
//        make.right.equalTo(self.userView).offset(-15);
//        make.centerY.equalTo(self.userView);
//    }];
}

-(CCPlayOperatingView *)playOperatingView{
    if(!_playOperatingView){
        _playOperatingView = [[CCPlayOperatingView alloc]init];
        __block typeof(self) weakself = self;
        _playOperatingView.clickClosedownBtn = ^{
//            [weakself.navigationController popViewControllerAnimated:YES];
        };
    }
    return _playOperatingView;
}

-(void)setModel:(CCLivePlatformModel *)model{
    _model = model;
    self.playOperatingView.livePlatformModel = model;
//    [self setOption];
    [self initView];
    
//    [self.userImageView setImageWithURL:[NSURL URLWithString:model.img] placeholder:[UIImage imageNamed:@"平台icon"]];
//    self.userNameLabel.text = model.title;
//    
//    float textw = [model.title widthForFont:[UIFont systemFontOfSize:12]]+2;
//    
//    if(textw > (MCScreenWidth-150)){
//        textw = MCScreenWidth-150;
//    }
//    
//    [self.userView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(20);
//        make.top.equalTo(self).offset(MCStatusBarHeight+5);
//        make.height.equalTo(@30);
//        make.width.equalTo(@(textw+50));
//    }];
//    [self.userImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.bottom.equalTo(self.userView);
//        make.width.equalTo(@30);
//    }];
//    [self.userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.userImageView.mas_right).offset(5);
//        make.width.equalTo(@(textw));
//        make.centerY.equalTo(self.userView);
//    }];
}

-(void)setOption{
    _option = [PLPlayerOption defaultOption];
    [_option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    [_option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
    [_option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
    [_option setOptionValue:@(YES) forKey:PLPlayerOptionKeyVideoToolbox];
    [_option setOptionValue:@(kPLLogInfo) forKey:PLPlayerOptionKeyLogLevel];
    
    self.player = [PLPlayer playerWithURL:[NSURL URLWithString:_model.play_url] option:self.option];
    self.player.delegate = self;
    [self addSubview:self.player.playerView];
    
    [self.player play];
}

-(UIView *)userView{
    if(!_userView){
        _userView = [[UIView alloc]init];
        _userView.backgroundColor = MCUIColorFromRGB(0xcccccc);
        _userView.layer.masksToBounds = YES;
        _userView.layer.cornerRadius = 15;
    }
    return _userView;
}

-(UIImageView *)userImageView{
    if (!_userImageView) {
        _userImageView = [[UIImageView alloc]init];
        _userImageView.layer.masksToBounds = YES;
        _userImageView.layer.cornerRadius = 15;
    }
    return _userImageView;
}

-(UILabel *)userNameLabel{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc]init];
        _userNameLabel.font = [UIFont boldSystemFontOfSize:12];
        _userNameLabel.textColor = MCUIColorFromRGB(0x000000);
        _userNameLabel.text = @"平台名称";
    }
    return _userNameLabel;
}

-(void)player:(PLPlayer *)player stoppedWithError:(NSError *)error{
    if (error) {
        [self.player stop];
        [CCView BSMBProgressHUD_onlyTextWithView:self andText:@"服务器播放错误，请稍后再试！"];
    }
}

-(void)dealloc{
    [self.player stop];
}


@end
