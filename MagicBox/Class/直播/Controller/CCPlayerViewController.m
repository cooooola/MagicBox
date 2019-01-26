//
//  CCPlayerViewController.m
//  MagicBox
//
//  Created by cola on 2019/1/23.
//  Copyright © 2019年 hello. All rights reserved.
//

#import "CCPlayerViewController.h"
#import "CCLivePlatformModel.h"
#import "CCVideoView.h"



@interface CCPlayerViewController ()
@property(nonatomic,strong)CCLivePlatformModel  *livePlatformModel;
@property(nonatomic, strong) NSArray           *videos;
@property(nonatomic, assign) NSInteger         playIndex;
@property(nonatomic,strong)CCVideoView *videoView;

@property(nonatomic,strong)UIButton *closedownButton;//关闭
@end

@implementation CCPlayerViewController

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
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.videoView];
    
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.videoView setModels:self.videos index:self.playIndex];
    
    [self.view addSubview:self.closedownButton];
    [self.closedownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-30);
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@60);
    }];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![@"YES" isEqualToString:[userDefaults objectForKey:@"isShowPlayerMassage"]]) {
        [userDefaults setObject:@"YES" forKey:@"isShowPlayerMassage"];
        [CCView BSMBProgressHUD_onlyTextWithView:[AppDelegate sharedApplicationDelegate].window andText:@"您可以上下滑动切换主播哟！"];
    }
}

- (instancetype)initWithVideos:(NSArray *)videos index:(NSInteger)index{
    if (self = [super init]) {
        self.videos = videos;
        self.playIndex = index;
    }
    return self;
}


-(CCVideoView *)videoView{
    if (!_videoView) {
        _videoView = [[CCVideoView alloc]initWithViewController:self];
    }
    return _videoView;
}

-(UIButton *)closedownButton{
    if(!_closedownButton){
        _closedownButton = [[UIButton alloc]init];
        [_closedownButton setImage:[UIImage imageNamed:@"closedown_icon"] forState:UIControlStateNormal];
        [_closedownButton addTarget:self action:@selector(clickClosedownButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closedownButton;
}

-(void)clickClosedownButton{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
