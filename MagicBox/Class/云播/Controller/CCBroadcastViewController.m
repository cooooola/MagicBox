//
//  CCBroadcastViewController.m
//  MagicBox
//
//  Created by hello on 2018/11/2.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCBroadcastViewController.h"
#import "SDCycleScrollView.h"

#import "CCCloudBroadcastViewController.h"


@interface CCBroadcastViewController ()<SDCycleScrollViewDelegate>{
    NSArray *buttonArray;
}
@property(nonatomic,strong)SDCycleScrollView *bannerView;
@property(nonatomic,strong)NSMutableArray *imageArray;
@end

@implementation CCBroadcastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getAd];
}

-(void)initView{
    [super initView];
    self.navigationItem.title = @"大黄鸭";
    self.backgroundImageView.frame = CGRectMake(0, kAdapterWith(140)+20, MCScreenWidth, MCScreenHeight-kAdapterWith(140)-20-MCTopHeight-MCTabBarHeight);
    self.backgroundImageView.image = [UIImage imageNamed:@"云播背景"];
    
    [self setupBannerView];
    
    buttonArray = [NSArray arrayWithObjects:@"小黄瓜影院",@"AV影院",@"Pornhub", nil];
    for (int i = 0; i < buttonArray.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(kAdapterWith(25), kAdapterWith(35+90*i), MCScreenWidth-kAdapterWith(50), kAdapterWith(60))];
        button.tag = i;
        [button setImage:[UIImage imageNamed:[buttonArray objectAtIndex:i]] forState:UIControlStateNormal];
        button.imageView.clipsToBounds = YES;
        [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
        UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, button.width, button.height/2)];
        titlelabel.text = [NSString stringWithFormat:@"%@",[buttonArray objectAtIndex:i]];
        titlelabel.textAlignment = NSTextAlignmentCenter;
        titlelabel.textColor = [UIColor whiteColor];
        titlelabel.font = [UIFont boldSystemFontOfSize:kAdapterWith(20)];
        [button addSubview:titlelabel];
        
        UILabel *subtitlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0,titlelabel.bottom, kAdapterWith(80), button.height/4)];
        subtitlelabel.centerX = titlelabel.centerX;
        subtitlelabel.backgroundColor = MCUIColorMain;
        subtitlelabel.text = @"点击进入播放";
        subtitlelabel.textAlignment = NSTextAlignmentCenter;
        subtitlelabel.textColor = [UIColor whiteColor];
        subtitlelabel.font = [UIFont systemFontOfSize:kAdapterWith(12)];
        subtitlelabel.clipsToBounds = YES;
        subtitlelabel.layer.cornerRadius = 3;
        [button addSubview:subtitlelabel];
        
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.backgroundImageView addSubview:button];
    }
}

-(void)setupBannerView{
    _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(10,10, MCScreenWidth-20, kAdapterWith(140)) delegate:self placeholderImage:[UIImage imageNamed:@"banner"]];
    [self.view addSubview:_bannerView];
    _bannerView.showPageControl = YES;
    _bannerView.imageURLStringsGroup = [NSArray arrayWithArray:self.imageArray];
    _bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
}

-(void)clickButton:(UIButton *)sender{
    CCCloudBroadcastViewController *cbvc = [[CCCloudBroadcastViewController alloc]init];
    cbvc.title = [buttonArray objectAtIndex:sender.tag];
    cbvc.cloudBroadcastType = (CloudBroadcastType)sender.tag;
    [self.navigationController pushViewController:cbvc animated:YES];
}

-(void)getAd{
    NSArray *array = [AppDelegate sharedApplicationDelegate].fileConfigurationModel.silderadv;
    _imageArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i ++) {
        CCSilderadvModel *model = [array objectAtIndex:i];
        [_imageArray addObject:model.slide_pic];
    }
    _bannerView.imageURLStringsGroup = [NSArray arrayWithArray:_imageArray];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    CCSilderadvModel *model = [[AppDelegate sharedApplicationDelegate].fileConfigurationModel.silderadv objectAtIndex:index];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.slide_url]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
