//
//  CCWelfareViewController.m
//  MagicBox
//
//  Created by hello on 2018/11/2.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCWelfareViewController.h"
#import "SDCycleScrollView.h"
#import "CCVIPViewingViewController.h"
#import "CCImageViewController.h"
#import "CCEroticNovelViewController.h"

@interface CCWelfareViewController ()<SDCycleScrollViewDelegate>
@property(nonatomic,strong)SDCycleScrollView *bannerView;
@property(nonatomic,strong)NSMutableArray *imageArray;
@end

@implementation CCWelfareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getAd];
}

-(void)initView{
    [super initView];
    self.navigationItem.title = @"大黄鸭";
    self.backgroundImageView.frame = CGRectMake(0, kAdapterWith(140)+20, MCScreenWidth, MCScreenHeight-kAdapterWith(140)-20-MCTopHeight-MCTabBarHeight);
    self.backgroundImageView.image = [UIImage imageNamed:@"福利背景"];
    
    [self setupBannerView];
    
    NSArray *buttonArray = [NSArray arrayWithObjects:@"激情图",@"情色小说",@"VIP观影", nil];
    for (int i = 0; i < buttonArray.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(kAdapterWith(25), kAdapterWith(35+80*i), MCScreenWidth-kAdapterWith(50), kAdapterWith(60))];
        button.tag = i;
        [button setImage:[UIImage imageNamed:[buttonArray objectAtIndex:i]] forState:UIControlStateNormal];
        button.imageView.clipsToBounds = YES;
        [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
        
        UILabel *titlelabel = [[UILabel alloc]initWithFrame:button.bounds];
        titlelabel.text = [NSString stringWithFormat:@"%@",[buttonArray objectAtIndex:i]];
        titlelabel.textAlignment = NSTextAlignmentCenter;
        titlelabel.textColor = [UIColor whiteColor];
        titlelabel.font = [UIFont boldSystemFontOfSize:kAdapterWith(24)];
        [button addSubview:titlelabel];
        
        [button addTarget:self action:@selector(clickButon:) forControlEvents:UIControlEventTouchUpInside];
        
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

-(void)clickButon:(UIButton *)sender{
    switch (sender.tag) {
        case 0:{
            CCImageViewController *ivc = [[CCImageViewController alloc]init];
            [self.navigationController pushViewController:ivc animated:YES];
        }break;
        case 1:{
            CCEroticNovelViewController *envc = [[CCEroticNovelViewController alloc]init];
            [self.navigationController pushViewController:envc animated:YES];
        }break;
        case 2:{
            CCVIPViewingViewController *vvvc = [[CCVIPViewingViewController alloc]init];
            [self.navigationController pushViewController:vvvc animated:YES];
        }break;
        default:
            break;
    }
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
