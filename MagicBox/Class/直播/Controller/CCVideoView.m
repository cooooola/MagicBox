//
//  CCVideoView.m
//  MagicBox
//
//  Created by cola on 2019/1/23.
//  Copyright © 2019年 hello. All rights reserved.
//

#import "CCVideoView.h"
#import "CCPlayerView.h"

@interface CCVideoView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView              *scrollView;
@property(nonatomic,strong)CCPlayerView *topView;
@property(nonatomic,strong)CCPlayerView *ctrView;
@property(nonatomic,strong)CCPlayerView *btmView;
@property(nonatomic,strong)CCPlayerView *currentPlayView;

// 控制播放的索引，不完全等于当前播放内容的索引
@property (nonatomic, assign) NSInteger                 index;

// 当前播放内容是h索引
@property (nonatomic, assign) NSInteger                 currentPlayIndex;

@property (nonatomic, weak) UIViewController            *vc;
@property (nonatomic, assign) BOOL                      isPushed;

@property (nonatomic, strong) NSMutableArray            *videos;

//@property (nonatomic, strong) GKDYVideoPlayer           *player;

// 记录播放内容
@property (nonatomic, copy) NSString                    *currentPlayId;

// 记录滑动前的播放状态
@property (nonatomic, assign) BOOL                      isPlaying_beforeScroll;

@property (nonatomic, assign) BOOL                      isRefreshMore;
@end

@implementation CCVideoView
- (instancetype)initWithViewController:(UIViewController *)viewController{
    if (self = [super init]){
        self.vc = viewController;
        [self initView];
    }
    return self;
}

-(void)initView{
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.topView.frame   = CGRectMake(0, 0, MCScreenWidth, MCScreenHeight);
    self.ctrView.frame   = CGRectMake(0, MCScreenHeight, MCScreenWidth, MCScreenHeight);
    self.btmView.frame   = CGRectMake(0, 2 * MCScreenHeight, MCScreenWidth, MCScreenHeight);
}

#pragma mark - Public Methods
- (void)setModels:(NSArray *)models index:(NSInteger)index {
    [self.videos removeAllObjects];
    [self.videos addObjectsFromArray:models];
    
    self.index = index;
    self.currentPlayIndex = index;
    
    if (models.count == 0) return;
    
    if (models.count == 1) {
        [self.ctrView removeFromSuperview];
        [self.btmView removeFromSuperview];
        
        self.scrollView.contentSize = CGSizeMake(0, MCScreenHeight);
        
        self.topView.model = self.videos.firstObject;
//
        [self playVideoFrom:self.topView];
    }else if (models.count == 2) {
        [self.btmView removeFromSuperview];
        
        self.scrollView.contentSize = CGSizeMake(0, MCScreenHeight * 2);
        
        self.topView.model = self.videos.firstObject;
        self.ctrView.model = self.videos.lastObject;
        
        if (index == 1) {
            self.scrollView.contentOffset = CGPointMake(0, MCScreenHeight);
            
            [self playVideoFrom:self.ctrView];
        }else {
            [self playVideoFrom:self.topView];
        }
    }else {
        if (index == 0) {   // 如果是第一个，则显示上视图，且预加载中下视图
            self.topView.model = self.videos[index];
            self.ctrView.model = self.videos[index + 1];
            self.btmView.model = self.videos[index + 2];

            // 播放第一个
            [self playVideoFrom:self.topView];
        }else if (index == models.count - 1) { // 如果是最后一个，则显示最后视图，且预加载前两个
            self.btmView.model = self.videos[index];
            self.ctrView.model = self.videos[index - 1];
            self.topView.model = self.videos[index - 2];

            // 显示最后一个
            self.scrollView.contentOffset = CGPointMake(0, MCScreenHeight * 2);
            // 播放最后一个
            [self playVideoFrom:self.btmView];
        }else { // 显示中间，播放中间，预加载上下
            self.ctrView.model = self.videos[index];
            self.topView.model = self.videos[index - 1];
            self.btmView.model = self.videos[index + 1];
            
            // 显示中间
            self.scrollView.contentOffset = CGPointMake(0, MCScreenHeight);
            // 播放中间
            [self playVideoFrom:self.ctrView];
        }
    }
}

// 添加播放数据后，重置index，防止出现错位的情况
- (void)addModels:(NSArray *)models index:(NSInteger)index {
    [self.videos addObjectsFromArray:models];
    
    self.index = index;
    self.currentPlayIndex = index;
    
    if (self.videos.count == 0) return;
    
    if (self.videos.count == 1) {
        [self.ctrView removeFromSuperview];
        [self.btmView removeFromSuperview];
        
        self.scrollView.contentSize = CGSizeMake(0, MCScreenHeight);
        
        self.topView.model = self.videos.firstObject;
        
        [self playVideoFrom:self.topView];
    }else if (self.videos.count == 2) {
        [self.btmView removeFromSuperview];
        
        self.scrollView.contentSize = CGSizeMake(0, MCScreenHeight * 2);
        
        self.topView.model = self.videos.firstObject;
        self.ctrView.model = self.videos.lastObject;
        
        if (index == 1) {
            self.scrollView.contentOffset = CGPointMake(0, MCScreenHeight);
            
            [self playVideoFrom:self.ctrView];
        }else {
            [self playVideoFrom:self.topView];
        }
    }else {
        if (index == 0) {   // 如果是第一个，则显示上视图，且预加载中下视图
            self.topView.model = self.videos[index];
            self.ctrView.model = self.videos[index + 1];
            self.btmView.model = self.videos[index + 2];
            
            // 播放第一个
            [self playVideoFrom:self.topView];
        }else if (index == self.videos.count - 1) { // 如果是最后一个，则显示最后视图，且预加载前两个
            self.btmView.model = self.videos[index];
            self.ctrView.model = self.videos[index - 1];
            self.topView.model = self.videos[index - 2];
            
            // 显示最后一个
            self.scrollView.contentOffset = CGPointMake(0, MCScreenHeight * 2);
            // 播放最后一个
            [self playVideoFrom:self.btmView];
        }else { // 显示中间，播放中间，预加载上下
            self.ctrView.model = self.videos[index];
            self.topView.model = self.videos[index - 1];
            self.btmView.model = self.videos[index + 1];
            
            // 显示中间
            self.scrollView.contentOffset = CGPointMake(0, MCScreenHeight);
            // 播放中间
            [self playVideoFrom:self.ctrView];
        }
    }
}

- (void)pause {
//    if (self.player.isPlaying) {
//        self.isPlaying_beforeScroll = YES;
//    }else {
//        self.isPlaying_beforeScroll = NO;
//    }
//
//    [self.player pausePlay];
}

- (void)resume {
    if (self.isPlaying_beforeScroll) {
//        [self.player resumePlay];
    }
}

- (void)destoryPlayer {
    self.scrollView.delegate = nil;
//    [self.player removeVideo];
}

#pragma mark - Private Methods
- (void)playVideoFrom:(CCPlayerView *)fromView {
    // 移除原来的播放
    [fromView.player play];
    
    // 取消原来视图的代理
//    self.currentPlayView.delegate = nil;
//
//    // 切换播放视图
    self.currentPlayId    = fromView.model.play_url;
    self.currentPlayView  = fromView;
    self.currentPlayIndex = [self indexOfModel:fromView.model];
//    // 设置新视图的代理
//    self.currentPlayView.delegate = self;
}

// 获取当前播放内容的索引
- (NSInteger)indexOfModel:(CCLivePlatformModel *)model {
    __block NSInteger index = 0;
    [self.videos enumerateObjectsUsingBlock:^(CCLivePlatformModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.play_url isEqualToString:obj.play_url]) {
            index = idx;
        }
    }];
    return index;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 小于等于三个，不用处理
    if (self.videos.count <= 3) return;
    
    // 上滑到第一个
    if (self.index == 0 && scrollView.contentOffset.y <= MCScreenHeight) {
        return;
    }
    // 下滑到最后一个
    if (self.index == self.videos.count - 1 && scrollView.contentOffset.y > MCScreenHeight) {
        return;
    }
    
    // 判断是从中间视图上滑还是下滑
    if (scrollView.contentOffset.y >= 2 * MCScreenHeight) {  // 上滑
//        [self.player removeVideo];  // 在这里移除播放，解决闪动的bug
        if (self.index == 0) {
            self.index += 2;
            
            scrollView.contentOffset = CGPointMake(0, MCScreenHeight);
            
            self.topView.model = self.ctrView.model;
            self.ctrView.model = self.btmView.model;
            
        }else {
            self.index += 1;
            
            if (self.index == self.videos.count - 1) {
                self.ctrView.model = self.videos[self.index - 1];
            }else {
                scrollView.contentOffset = CGPointMake(0, MCScreenHeight);
                
                self.topView.model = self.ctrView.model;
                self.ctrView.model = self.btmView.model;
            }
        }
        if (self.index < self.videos.count - 1) {
            self.btmView.model = self.videos[self.index + 1];
        }
    }else if (scrollView.contentOffset.y <= 0) { // 下滑
//        [self.player removeVideo];  // 在这里移除播放，解决闪动的bug
        if (self.index == 1) {
            self.topView.model = self.videos[self.index - 1];
            self.ctrView.model = self.videos[self.index];
            self.btmView.model = self.videos[self.index + 1];
            self.index -= 1;
        }else {
            if (self.index == self.videos.count - 1) {
                self.index -= 2;
            }else {
                self.index -= 1;
            }
            scrollView.contentOffset = CGPointMake(0, MCScreenHeight);
            
            self.btmView.model = self.ctrView.model;
            self.ctrView.model = self.topView.model;
            
            if (self.index > 0) {
                self.topView.model = self.videos[self.index - 1];
            }
        }
    }
    
    if (self.isPushed) return;
    
    // 自动刷新，如果想要去掉自动刷新功能，去掉下面代码即可
    if (scrollView.contentOffset.y == MCScreenHeight) {
        if (self.isRefreshMore) return;
        
        // 播放到倒数第二个时，请求更多内容
        if (self.currentPlayIndex == self.videos.count - 2) {
            self.isRefreshMore = YES;
//            [self refreshMore];
        }
    }
    
    if (self.isRefreshMore) return;
    
    if (scrollView.contentOffset.y == 2 * MCScreenHeight) {
//        [self refreshMore];
    }
}

// 结束滚动后开始播放
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y == 0) {
        if (self.currentPlayId == self.topView.model.play_url) return;
        [self.ctrView.player stop];
        [self.btmView.player stop];
        [self playVideoFrom:self.topView];
    }else if (scrollView.contentOffset.y == MCScreenHeight) {
        if (self.currentPlayId == self.ctrView.model.play_url) return;
        [self.topView.player stop];
        [self.btmView.player stop];
        [self playVideoFrom:self.ctrView];
    }else if (scrollView.contentOffset.y == 2 * MCScreenHeight) {
        if (self.currentPlayId == self.btmView.model.play_url) return;
        [self.topView.player stop];
        [self.ctrView.player stop];
        [self playVideoFrom:self.btmView];
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        [_scrollView addSubview:self.topView];
        [_scrollView addSubview:self.ctrView];
        [_scrollView addSubview:self.btmView];
        _scrollView.contentSize = CGSizeMake(0,  MCScreenHeight* 3);
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

-(CCPlayerView *)topView{
    if (!_topView) {
        _topView = [[CCPlayerView alloc]init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

-(CCPlayerView *)ctrView{
    if (!_ctrView) {
        _ctrView = [[CCPlayerView alloc]init];
        _ctrView.backgroundColor = [UIColor redColor];
    }
    return _ctrView;
}

-(CCPlayerView *)btmView{
    if (!_btmView) {
        _btmView = [[CCPlayerView alloc]init];
        _btmView.backgroundColor = [UIColor blackColor];
    }
    return _btmView;
}

-(NSMutableArray *)videos{
    if (!_videos) {
        _videos = [NSMutableArray array];
    }
    return _videos;
}

@end
