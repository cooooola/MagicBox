//
//  CCPlayOperatingView.m
//  MagicBox
//
//  Created by hello on 2018/11/9.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCPlayOperatingView.h"
#import "DMHeartFlyView.h"
#import "CCImgModel.h"

@interface CCPlayOperatingView(){
    CGFloat _heartSize;
    NSTimer *_burstTimer;
}
//@property(nonatomic,strong)UIButton *closedownButton;//关闭
@property(nonatomic,strong)UIButton *collectButton;//收藏

@property(nonatomic,strong)UIView *userView;
@property(nonatomic,strong)UIImageView *userImageView;
@property(nonatomic,strong)UILabel *userNameLabel;

@property(nonatomic,strong)UIImageView *adImageView;
@property(nonatomic,strong)UIButton *adButton;
@property(nonatomic,strong)CCImgModel *model;
@end

@implementation CCPlayOperatingView

-(void)initView{
    self.backgroundColor = [UIColor clearColor];
    
//    [self addSubview:self.closedownButton];
//    [self.closedownButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self).offset(-30);
//        make.centerX.equalTo(self);
//        make.width.height.equalTo(@60);
//    }];
    
    
    
//    [self addSubview:self.collectButton];
//    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).offset(-20);
//        make.top.equalTo(self).offset(MCStatusBarHeight+5);
//        make.width.height.equalTo(@40);
//    }];
    
    [self addSubview:self.userView];
    [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(MCStatusBarHeight+5);
        make.height.equalTo(@30);
        make.width.equalTo(@100);
    }];
    
    [self addSubview: self.adImageView];
    [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userView.mas_bottom).offset(10);
        make.left.equalTo(self.userView);
        make.height.equalTo(@40);
        make.width.equalTo(@100);
    }];
    
    [self addSubview:self.adButton];
    [self.adButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.adImageView);
    }];
    
    [self.userView addSubview:self.userImageView];
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.userView);
        make.width.equalTo(@30);
    }];
    [self.userView addSubview:self.userNameLabel];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImageView.mas_right).offset(5);
        make.right.equalTo(self.userView).offset(-15);
        make.centerY.equalTo(self.userView);
    }];
    
    [self likeSetting];
}

-(void)likeSetting{
    self.userInteractionEnabled = YES;
    _heartSize = 36;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showTheLove)];
    [self addGestureRecognizer:tapGesture];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
    longPressGesture.minimumPressDuration = 0.2;
    [self addGestureRecognizer:longPressGesture];
}

-(void)showTheLove{
    DMHeartFlyView* heart = [[DMHeartFlyView alloc]initWithFrame:CGRectMake(0, 0, _heartSize, _heartSize)];
    [self addSubview:heart];
    CGPoint fountainSource = CGPointMake(20 + _heartSize/2.0, self.bounds.size.height - _heartSize/2.0 - 10);
    heart.center = fountainSource;
    [heart animateInView:self];
}

-(void)longPressGesture:(UILongPressGestureRecognizer *)longPressGesture{
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
            _burstTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(showTheLove) userInfo:nil repeats:YES];
            break;
        case UIGestureRecognizerStateEnded:
            [_burstTimer invalidate];
            _burstTimer = nil;
            break;
        default:
            break;
    }
}


-(void)setLivePlatformModel:(CCLivePlatformModel *)livePlatformModel{
    _livePlatformModel = livePlatformModel;
    [self.userImageView setImageWithURL:[NSURL URLWithString:livePlatformModel.img] placeholder:[UIImage imageNamed:@"平台icon"]];
    self.userNameLabel.text = livePlatformModel.title;
    
    float textw = [livePlatformModel.title widthForFont:[UIFont systemFontOfSize:12]]+2;
    
    if(textw > (MCScreenWidth-150)){
        textw = MCScreenWidth-150;
    }
    
    [self.userView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(MCStatusBarHeight+5);
        make.height.equalTo(@30);
        make.width.equalTo(@(textw+50));
    }];
    [self.userImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.userView);
        make.width.equalTo(@30);
    }];
    [self.userNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImageView.mas_right).offset(5);
        make.width.equalTo(@(textw));
        make.centerY.equalTo(self.userView);
    }];
}

//-(UIButton *)closedownButton{
//    if(!_closedownButton){
//        _closedownButton = [[UIButton alloc]init];
//        [_closedownButton setImage:[UIImage imageNamed:@"closedown_icon"] forState:UIControlStateNormal];
//        [_closedownButton addTarget:self action:@selector(clickClosedownButton) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _closedownButton;
//}

-(UIButton *)collectButton{
    if(!_collectButton){
        _collectButton = [[UIButton alloc]init];
        [_collectButton setImage:[UIImage imageNamed:@"collect_icon"] forState:UIControlStateNormal];
//        [_collectButton addTarget:self action:@selector(clickClosedownButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectButton;
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

-(UIImageView *)adImageView{
    if (!_adImageView) {
        _adImageView = [[UIImageView alloc]init];
        _adImageView.layer.masksToBounds = YES;
        _adImageView.layer.cornerRadius = 20;
        _adImageView.contentMode = UIViewContentModeScaleToFill;
        NSArray *array = [AppDelegate sharedApplicationDelegate].fileConfigurationModel.liveadv;
        if (array.count == 0) {
            _adImageView.hidden = YES;
        }else{
           _adImageView.hidden = NO;
            int r = arc4random() % [array count];
            _model = [array objectAtIndex:r];
            [_adImageView setImageURL:[NSURL URLWithString:_model.img]];
        }
    }
    return _adImageView;
}

-(UIButton *)adButton{
    if (!_adButton) {
        _adButton = [[UIButton alloc]init];
        [_adButton addTarget:self action:@selector(clickAdButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _adButton;
}

-(void)clickClosedownButton{
    if(self.clickClosedownBtn){
        self.clickClosedownBtn();
    }
}

-(void)clickAdButton{
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_model.url]];
}

@end
