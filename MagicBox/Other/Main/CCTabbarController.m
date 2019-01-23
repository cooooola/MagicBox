//
//  CCTabbarController.m
//  SchoolMakeUp
//
//  Created by goulela on 16/9/26.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "CCTabbarController.h"
#import "UIImage+image.h"



@interface CCTabbarController ()<UITabBarControllerDelegate>

@property(nonatomic,strong)UINavigationController *findNav;
@end

@implementation CCTabbarController

//修改本类下的TabbarItem的字体颜色
+ (void)initialize{
    //获取当前类下的UITabbarItem

    UITabBarItem * item = [UITabBarItem appearance];

    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = [UIColor colorWithRed:255/255.0 green:223/255.0 blue:23/255.0 alpha:1.0];
    
    [item setTitleTextAttributes:dic forState:UIControlStateSelected];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.delegate = self;
    self.tabBar.backgroundImage = [CCTool imageWithColor:[UIColor blackColor]];
    
    //添加所有自控制器
    [self addAllChildViewController];
    
}

- (void)addAllChildViewController{
//    KKHomeViewController *home = [[KKHomeViewController alloc] init];
//    MCNavigationController * homeNav = [[MCNavigationController alloc] initWithRootViewController:home];
//    [self setUpOneChildViewController:homeNav image:@"myinfo3-67-16" selectedImage:@"index7-6-4" andTitle:@"大厅"];
//
//    //
//    KKRechargeViewController * recharege = [[KKRechargeViewController alloc] init];
//    MCNavigationController * recharegeNav = [[MCNavigationController alloc] initWithRootViewController:recharege];
//    [self setUpOneChildViewController:recharegeNav image:@"Group" selectedImage:@"pay-3-10-16" andTitle:@"充值"];
//
//    //
////    KKFindViewController *findVC = [[KKFindViewController alloc] init];
//    KKTrendViewController *findVC = [[KKTrendViewController alloc]init];
//    self.findNav = [[MCNavigationController alloc] initWithRootViewController:findVC];
//    [self setUpOneChildViewController:self.findNav image:@"Group 2" selectedImage:@"descover-23-4-3" andTitle:@"发现"];
//
//
//    if([[MCTool BSGetObjectForKey:BSActivityViewControllerState] integerValue]){
//        KKActivityViewController * activity = [[KKActivityViewController alloc] init];
//        MCNavigationController * activityNav = [[MCNavigationController alloc] initWithRootViewController:activity];
//        [self setUpOneChildViewController:activityNav image:@"myinfo-43-67-16" selectedImage:@"Discount-5-3-3" andTitle:@"活动"];
//    }
//    // 我的
//    KKMineViewController * mine = [[KKMineViewController alloc] init];
//    MCNavigationController * mineNav = [[MCNavigationController alloc] initWithRootViewController:mine];
//    [self setUpOneChildViewController:mineNav image:@"index7-2-4" selectedImage:@"myinfo-43-63-3" andTitle:@"我的"];
}

#pragma mark 添加一个子控制器
- (void)setUpOneChildViewController:(UINavigationController *)nav image:(NSString *)image selectedImage:(NSString *)selectedImage andTitle:(NSString *)title{
    nav.view.backgroundColor = [UIColor whiteColor];
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [UIImage imageWithOriginalName:image];
    
    //添加一张原始的没有被渲染的图片.
    nav.tabBarItem.selectedImage = [UIImage imageWithOriginalName:selectedImage];
    [self addChildViewController:nav];
}



@end
