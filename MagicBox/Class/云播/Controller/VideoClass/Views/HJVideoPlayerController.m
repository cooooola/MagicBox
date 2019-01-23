//
//  HJVideoPlayerController.m
//  HJVideoPlayer
//
//  Created by WHJ on 2016/12/8.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import "HJVideoPlayerController.h"
#import "HJVideoTopView.h"
#import "HJVideoBottomView.h"
#import "HJVideoPlayManager.h"
#import "HJVideoUIManager.h"
#import "HJPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "HJViewFactory.h"
#import "HJVideoMaskView.h"
#import "HJVideoPlayerHeader.h"
#import "AppDelegate+HJVideoRotation.h"
#import "HJVideoPlayerUtil.h"
#import "UIDevice+HJVideoRotation.h"
#import "HJVideoConst.h"
#import "HJVideoPlayTimeRecord.h"

typedef NS_ENUM(NSUInteger, MoveDirection) {
    MoveDirection_none = 0,
    MoveDirection_up,
    MoveDirection_down,
    MoveDirection_left,
    MoveDirection_right
};



@interface HJVideoPlayerController (){
    CCImgModel *imgModel;
}

@property (nonatomic ,strong) HJVideoMaskView * maskView;

@property (nonatomic ,strong) HJVideoTopView * topView;

@property (nonatomic ,strong) HJVideoBottomView * bottomView;

@property (nonatomic ,assign) CGRect originFrame;

@property (nonatomic, assign) BOOL isFullScreen;

@property (nonatomic, strong) HJPlayerView *playerView;

@property (nonatomic, assign) VideoPlayerStatus playStatus;

@property (nonatomic, assign) VideoPlayerStatus prePlayStatus;
/** 隐藏时间 */
@property (nonatomic, assign) NSInteger secondsForBottom;
/** 开始移动 */
@property (nonatomic, assign) CGPoint startPoint;
/** 移动方向 */
@property (nonatomic, assign) MoveDirection moveDirection;
/** 音量调节 */
@property (nonatomic, strong) UISlider *volumeSlider;
/** 系统音量 */
@property (nonatomic, assign) CGFloat sysVolume;
/** 亮度调节 */
@property (nonatomic, assign) CGFloat brightness;
/** 进度调节 */
@property (nonatomic, assign) CGFloat currentTime;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;

@property(nonatomic,strong)UIImageView *adImageView;
@property(nonatomic,strong)UIButton *closedownButton;

@end

#define kFullScreenFrame CGRectMake(0 , 0, kVideoScreenH, kVideoScreenW)


static const NSInteger maxSecondsForBottom = 5.f;

@implementation HJVideoPlayerController

#pragma mark - 生命周期

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        self.originFrame = frame;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    [self initW];
    [self handleVideoPlayerStatus];
    [self handleProgress];
    [self addObservers];
    [self addTapGesture];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //允许屏幕旋转
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (self.configModel.onlyFullScreen) {
        delegate.orientationMask = UIInterfaceOrientationMaskLandscape;
        [UIDevice rotateToOrientation:UIInterfaceOrientationLandscapeRight];
        [self changeFullScreen:YES];
    }else{
        delegate.orientationMask = UIInterfaceOrientationMaskAllButUpsideDown;
    }
    //禁用侧滑手势方法
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    //开启屏幕长亮
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self cancelTimer];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    //关闭屏幕旋转
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.orientationMask = UIInterfaceOrientationMaskPortrait;
    [UIDevice rotateToOrientation:UIInterfaceOrientationPortrait];
    //关闭屏幕长亮
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    //禁用侧滑手势方法
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    //暂停播放
    [self pause];
}


- (void)dealloc{
    [kVideoPlayerManager reset];
}



- (void)initW{
    self.secondsForBottom = maxSecondsForBottom;
    self.currentTime      = 0;
    
    //获取系统音量滚动条
    MPVolumeView *volumeView = [[MPVolumeView alloc]init];
    for (UIView *tmpView in volumeView.subviews) {
        if ([[tmpView.class description] isEqualToString:@"MPVolumeSlider"]) {
            self.volumeSlider = (UISlider *)tmpView;
        }
    }
}


- (void)clearInfo{
    if (_bottomView) {
        [self.bottomView setProgress:0];
        [self.bottomView setMaximumValue:0];
        [self.bottomView setBufferValue:0];
    }
    self.playStatus = videoPlayer_unknown;
    self.currentTime = 0;
}

#pragma mark - About UI
- (void)setupUI{
    [self.view removeAllSubviews];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kVideoScreenW));
        make.height.equalTo(@(kVideoScreenW/4*3));
        make.center.equalTo(self.view);
    }];
    

    [self.playerView addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playerView);
    }];
    
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@(kBottomBarHalfHeight));
    }];
    
    // 设置BottomView
    self.bottomView.frame = CGRectMake(0,400, self.view.frame.size.width, kBottomBarHalfHeight);
    self.bottomView.configModel = self.configModel;
    [self.view addSubview:self.bottomView];
    
    [self setADimageView];
}

- (void)changeUI{
    [self.view removeAllSubviews];
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    [self.playerView addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.playerView);
    }];
    
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@(kBottomBarHalfHeight));
    }];
    
    // 设置BottomView
    self.bottomView.frame = CGRectMake(0,0, self.view.frame.size.width, kBottomBarHalfHeight);
    self.bottomView.configModel = self.configModel;
    [self.view addSubview:self.bottomView];
    
    [self setADimageView];
}




- (void)changeFullScreen:(BOOL)changeFull{
    
    self.isFullScreen = changeFull;
  
    [self.view.superview bringSubviewToFront:self.view];
    
    [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
        
        if (changeFull) {
            [self changeUI];
        }else{
            [self setupUI];
        }
        
        
        // 发送屏幕改变通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationChangeScreen object:@(changeFull)];
    }];
}
#pragma mark - 底部栏显示/隐藏

- (void)addTapGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(startTimer)];
    [self.view addGestureRecognizer:tap];
    [self startTimer];
}

- (void)showBottomAction{
    if (!self.bottomView.onlySlider) {
        [self.bottomView hide];
    }else{
        [self.bottomView show];
    }
}


- (void)startTimer{
    //看是否正在计时，若是则结束计时 否则开始计时
    if (self.timer) {
        [self cancelTimerAndHideViews];
        
    }else{
        [self setSecondsForBottom:maxSecondsForBottom];
        [self hideTopView:NO];
        [self.bottomView show];
        
        [self.maskView show];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self
                                                    selector:@selector(timerAction)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}


- (void)resetTimer{
    
    if ([self.timer isValid]) {
        self.secondsForBottom = 5.f;
    }else{
        [self startTimer];
    }
}


- (void)cancelTimerAndHideViews{
    
    [self hideSomeViews];
    
    [self cancelTimer];
}


- (void)cancelTimer{
    if (!self.timer) {
        return;
    }
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)hideSomeViews{
    
    //顶部视图隐藏
    if (self.isFullScreen) {
        [self hideTopView:YES];
    }
    
    //底部视图隐藏
    [self.bottomView hide];
    
    //中间内容隐藏 暂停 播放失败 和播放结束 无需隐藏显示内容
    if(self.playStatus != videoPlayer_readyToPlay && 
       self.maskView.maskViewStatus != VideoMaskViewStatus_showLoading &&
       self.maskView.maskViewStatus != VideoMaskViewStatus_showPlayFailed &&
       !self.maskView.isPausing){
        [self.maskView hide];
    }
    
    self.secondsForBottom = 0;
}


- (void)hideTopView:(BOOL)hide{

    self.topView.hidden = hide;
    //状态栏显示跟随topView
    [[UIApplication sharedApplication] setStatusBarHidden:hide withAnimation:NO];
}


- (void)timerAction{
    
        self.secondsForBottom --;
        NSLog(@"隐藏底部栏:%zd",self.secondsForBottom);
        if (self.secondsForBottom <= 0) {
            [self cancelTimerAndHideViews];
        }
}


#pragma mark - Pravite Methods
- (void)handleVideoPlayerStatus{
    
    WS(weakSelf);
    [kVideoPlayerManager readyBlock:^(CGFloat totoalDuration) {
        NSLog(@"[%@]:准备播放",[weakSelf class]);
        weakSelf.playStatus = videoPlayer_readyToPlay;
        if (weakSelf.configModel.autoPlay) {//是否自动播放
            [weakSelf play];
        }else{
            weakSelf.maskView.maskViewStatus = VideoMaskViewStatus_showPlayBtn;
        }
    } monitoringBlock:^(CGFloat currentDuration) {
    
        if(weakSelf.playStatus!= videoPlayer_pause){
            weakSelf.playStatus = videoPlayer_playing;
        }

        if(weakSelf.maskView.maskViewStatus != VideoMaskViewStatus_showPlayBtn) {
            weakSelf.maskView.maskViewStatus = VideoMaskViewStatus_showPlayBtn;
            [weakSelf hideSomeViews];
        };
    }loadingBlock:^{
        NSLog(@"[%@]:加载中",[weakSelf class]);
        weakSelf.playStatus = videoPlayer_loading;
        weakSelf.maskView.maskViewStatus = VideoMaskViewStatus_showLoading;
    }endBlock:^{
        NSLog(@"[%@]:播放结束",[weakSelf class]);
        weakSelf.playStatus = videoPlayer_playEnd;
        weakSelf.maskView.maskViewStatus = VideoMaskViewStatus_showReplayBtn;
        if (weakSelf.playEndBlock) {
            weakSelf.playEndBlock();
        }
    } failedBlock:^{
        NSLog(@"[%@]:播放失败",[weakSelf class]);
        weakSelf.playStatus = videoPlayer_playFailed;
        weakSelf.maskView.maskViewStatus = VideoMaskViewStatus_showPlayFailed;
    }];
}
/**
 *  设置时长
 */
- (void)handleProgress{
    
    WS(weakSelf);
    [kVideoPlayerManager totalDurationBlock:^(CGFloat totalDuration) {
        [weakSelf.bottomView setMaximumValue:totalDuration];
    } currentDurationBlock:^(CGFloat currentDuration) {
        [weakSelf.bottomView setProgress:currentDuration];
    } bufferDurationBlock:^(CGFloat bufferDuration) {
        [weakSelf.bottomView setBufferValue:bufferDuration];
    }];
}

- (void)addObservers{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

}


#pragma mark - 公开方法
- (void)play{
    
    //若有记录则从记录播放
    if ([kVideoPlayerManager recordWithUrl:self.url]) {
        HJVideoPlayTimeRecord * record = [kVideoPlayerManager recordWithUrl:self.url];
        [kVideoPlayerManager seekToTime:record.playTime];
        [kVideoPlayerManager removeRecord:record];
    }
    
    [kVideoPlayerManager play];
    [self setPlayStatus:videoPlayer_playing];
    [self.maskView setPlayStatus:YES];
}

- (void)pause{
    
    [kVideoPlayerManager pause];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setPlayStatus:videoPlayer_pause];
        [self.maskView setPlayStatus:NO];
    });
    
    [self setADimageView];
}


- (void)pausePlayAndBuffer{

    [self pause];
    
    [kVideoPlayerManager cancelBuffer];
}


#pragma mark - 事件响应
- (void)applicationDidEnterBackground {

    if (self.playStatus == videoPlayer_playing) {
        [self pause];
    }
}


- (void)applicationWillEnterForeground {
   
    if (self.prePlayStatus == videoPlayer_playing) {
        [self play];
    }
}

- (void)playOrPauseAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self play];
    }else{
        [self pause];
    }
}


- (void)popAction{
    [self.navigationController popViewControllerAnimated:YES];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - getters / setters
- (HJVideoTopView *)topView{
    if (!_topView) {
        WS(weakSelf);
        _topView = [[HJVideoTopView alloc]init];
        _topView.backBlock = ^(){
            if (weakSelf.configModel.onlyFullScreen) {//仅支持全屏  直接返回
                weakSelf.view.frame = CGRectZero;
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                if(weakSelf.isFullScreen){//全屏返回
                    [UIDevice rotateToOrientation:UIInterfaceOrientationPortrait];
                    [weakSelf changeFullScreen:NO];
                }else{//半屏返回操作
                    [weakSelf popAction];
                }
            }
        };
        
        _topView.showListBlock = ^(BOOL show){
            
        };
    }
    return _topView;
}

- (HJVideoBottomView *)bottomView{
    if (!_bottomView) {
        WS(weakSelf);
        _bottomView = [[HJVideoBottomView alloc] init];
        _bottomView.fullScreenBlock = ^(BOOL isFull){
            if(isFull){
                [UIDevice rotateToOrientation:UIInterfaceOrientationLandscapeRight];
            }else{
                [UIDevice rotateToOrientation:UIInterfaceOrientationPortrait];
            }
            [weakSelf changeFullScreen:isFull];
        };
        _bottomView.valueChangedBlock = ^(float value) {
            [kVideoPlayerManager seekToTime:value];
        };
    }
    return _bottomView;
}

- (HJPlayerView *)playerView{
    if (!_playerView) {
        _playerView = [[HJPlayerView alloc] init];
        _playerView.backgroundColor = [UIColor clearColor];
        _playerView.image = imgVideoBackImg;
        _playerView.userInteractionEnabled = YES;
    }
    return _playerView;
}

-(HJVideoMaskView *)maskView{
    if (!_maskView) {
        _maskView = [[HJVideoMaskView alloc]init];
        _maskView.backgroundColor = kVideoMaskViewBGColor;
        _maskView.maskViewStatus = VideoMaskViewStatus_showPlayBtn;
        WS(weakSelf);
        _maskView.playBlock = ^(BOOL isPlay) {
            if (isPlay) {
                [weakSelf play];
            }else{
                [weakSelf pause];
            }
            [weakSelf resetTimer];
        };
        
        _maskView.replayBlock = ^{
            [kVideoPlayerManager seekToTime:0];
            weakSelf.maskView.maskViewStatus = VideoMaskViewStatus_showPlayBtn;
            [weakSelf resetTimer];
        };
        
        _maskView.playFailedClickBlock = ^{
            [weakSelf setUrl:weakSelf.url];
        };
    }
    return _maskView;
}




- (void)setUrl:(NSString *)url{
    if (!url) return;
    
    if (![_url isEqualToString:url]) {//若切换URL
        //清除视频标题
        self.videoTitle = @"";
    }
    
    //记录播放时长
    [kVideoPlayerManager recordUrl:_url playTime:self.bottomView.progressValue];
    
    _url = url;

    [self clearInfo];
    [self.playerView setPlayer:[kVideoPlayerManager setUrl:_url]];
    self.maskView.maskViewStatus = VideoMaskViewStatus_showLoading;
}

- (void)setVideoTitle:(NSString *)videoTitle{
    _videoTitle = videoTitle;
    self.topView.title = videoTitle;
}

- (void)setPlayStatus:(VideoPlayerStatus)playStatus{
    self.prePlayStatus = _playStatus;
    _playStatus = playStatus;
}

- (HJVideoConfigModel *)configModel{
    if (!_configModel) {
        _configModel = [[HJVideoConfigModel alloc] init];
        _configModel.autoPlay = YES;//默认设置url自动播放
    }
    return _configModel;
}


- (void)setIsFullScreen:(BOOL)isFullScreen{
    if (_isFullScreen != isFullScreen) {
        _isFullScreen = isFullScreen;
        //屏幕切换回调
        if (self.screenChangedBlock) {
            self.screenChangedBlock(isFullScreen);
        }
    }
}
#pragma mark - 触摸事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UITouch * touch = [touches anyObject];
    self.startPoint = [touch locationInView:self.view];
    self.sysVolume = self.volumeSlider.value;
    self.brightness = [UIScreen mainScreen].brightness;
    self.currentTime = self.bottomView.progressValue;
    //点击广告触发
    if ([touch.view isEqual:self.adImageView]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:imgModel.url]];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    if(self.playStatus == videoPlayer_unknown ||
       self.playStatus == videoPlayer_playFailed ||
       self.playStatus == videoPlayer_playEnd ||
       self.playStatus == videoPlayer_loading){
        return;
    }
    
    [self setSecondsForBottom:maxSecondsForBottom];
    UITouch * touch = [touches anyObject];
    CGPoint movePoint = [touch locationInView:self.view];
    
    CGFloat subX = movePoint.x - self.startPoint.x;
    CGFloat subY = movePoint.y - self.startPoint.y;
    CGFloat width  = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    BOOL startInLeft = movePoint.x < width/2.f;
    
    
    if (self.moveDirection == MoveDirection_none) {
        if (subX >= 30) {
            self.moveDirection = MoveDirection_right;
        }else if(subX <= -30){
            self.moveDirection = MoveDirection_left;
        }else if (subY >= 30){
            self.moveDirection = MoveDirection_down;
        }else if (subY <= -30){
            self.moveDirection = MoveDirection_up;
        }
    }
    
    if (self.moveDirection == MoveDirection_right || self.moveDirection == MoveDirection_left) {//快进
        CGFloat ratio = subX/width;
        CGFloat offsetSeconds = self.bottomView.maximumValue*ratio;
        CGFloat seekTime = self.currentTime + offsetSeconds;
        [self.maskView.fastForwardView setMaxDuration:self.bottomView.maximumValue];
        self.maskView.maskViewStatus = VideoMaskViewStatus_showFastForward;
        [self.maskView.fastForwardView moveRight:offsetSeconds>0];
        [self.maskView.fastForwardView setProgress:seekTime/self.bottomView.maximumValue];
        [self resetTimer];
        [self.bottomView hide];
    }else if (self.moveDirection == MoveDirection_up || self.moveDirection == MoveDirection_down){
        if (startInLeft) {//上调亮度
            [UIScreen mainScreen].brightness = self.brightness - subY/height;//10;
        }else{//上调音量
            self.volumeSlider.value = self.sysVolume - subY/height;//10;
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if (self.moveDirection == MoveDirection_left || self.moveDirection == MoveDirection_right) {
        [kVideoPlayerManager seekToTime:self.maskView.fastForwardView.currentDuration];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.playStatus = self.prePlayStatus;
            [self cancelTimerAndHideViews];
        });
    }
    [self setMoveDirection:MoveDirection_none];
    [self setCurrentTime:0];
}


#pragma mark - 屏幕旋转
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            [self changeFullScreen:YES];
        }else{
            [self changeFullScreen:NO];
        }
    });
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    
}


#pragma 广告
-(UIImageView *)adImageView{
    if (!_adImageView) {
        _adImageView = [[UIImageView alloc]init];
        _adImageView.contentMode =  UIViewContentModeScaleAspectFill;
        _adImageView.layer.masksToBounds = YES;
        _adImageView.userInteractionEnabled = YES;
    }
    return _adImageView;
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
    [self.closedownButton removeFromSuperview];
    [self.adImageView removeFromSuperview];
}

-(void)setADimageView{
    [self.playerView addSubview:self.adImageView];
    [self.adImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.maskView);
        make.width.height.equalTo(@(MCScreenWidth/2));
    }];
    NSArray *array = [AppDelegate sharedApplicationDelegate].fileConfigurationModel.roomadv;
    int r = arc4random() % [array count];
    imgModel = [array objectAtIndex:r];
    [self.adImageView setImageURL:[NSURL URLWithString:imgModel.img]];
    
    [self.adImageView addSubview:self.closedownButton];
    [self.closedownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.adImageView);
        make.width.height.equalTo(@30);
    }];
}


@end
