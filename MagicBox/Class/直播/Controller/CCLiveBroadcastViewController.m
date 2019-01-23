//
//  CCLiveBroadcastViewController.m
//  MagicBox
//
//  Created by hello on 2018/11/9.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCLiveBroadcastViewController.h"
#import "CCPlayOperatingView.h"
#import <PLPlayerKit/PLPlayerKit.h>

@interface CCLiveBroadcastViewController ()<PLPlayerDelegate>
@property(nonatomic,strong)PLPlayerOption *option;
@property(nonatomic,strong)PLPlayer  *player;
@property(nonatomic,strong)CCPlayOperatingView *playOperatingView;
@end

@implementation CCLiveBroadcastViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

-(void)initView{
    [self.player.playerView addSubview:self.playOperatingView];
    [self.playOperatingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.player.playerView);
    }];
}

-(CCPlayOperatingView *)playOperatingView{
    if(!_playOperatingView){
        _playOperatingView = [[CCPlayOperatingView alloc]init];
        __block typeof(self) weakself = self;
        _playOperatingView.clickClosedownBtn = ^{
            [weakself.navigationController popViewControllerAnimated:YES];
        };
    }
    return _playOperatingView;
}

-(void)setLivePlatformModel:(CCLivePlatformModel *)livePlatformModel{
    _livePlatformModel = livePlatformModel;
    self.playOperatingView.livePlatformModel = livePlatformModel;
    [self setOption];
}

-(void)setOption{
    _option = [PLPlayerOption defaultOption];
    [_option setOptionValue:@15 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    [_option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL1BufferDuration];
    [_option setOptionValue:@1000 forKey:PLPlayerOptionKeyMaxL2BufferDuration];
    [_option setOptionValue:@(YES) forKey:PLPlayerOptionKeyVideoToolbox];
    [_option setOptionValue:@(kPLLogInfo) forKey:PLPlayerOptionKeyLogLevel];
    
    self.player = [PLPlayer playerWithURL:[NSURL URLWithString:_livePlatformModel.play_url] option:self.option];
    self.player.delegate = self;
    [self.view addSubview:self.player.playerView];
    
    [self.player play];
}

-(void)player:(PLPlayer *)player stoppedWithError:(NSError *)error{
    if (error) {
        [self.player stop];
        [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"服务器播放错误，请稍后再试！"];
        
        __block typeof(self) weakSelf = self;
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5* NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [weakSelf.navigationController  popViewControllerAnimated:YES];
        });
    }
}




- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.player stop];
}

-(void)dealloc{
    [self.player stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
