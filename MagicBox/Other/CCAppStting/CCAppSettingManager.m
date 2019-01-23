//
//  CCAppSettingManager.m
//  
//
//  Created by hello on 2018/3/8.
//

#import "CCAppSettingManager.h"
#import <UIKit/UIKit.h>

#import "TabBarController.h"
#import "CCNavigationController.h"

#import "DWIntrosPageContentViewController.h"
#import "DWIntrosPagesViewController.h"

#import "CCMineViewController.h"
#import "CCWelfareViewController.h"
#import "CCBroadcastViewController.h"
#import "CCLiveViewController.h"

#import "CCFileConfigurationModel.h"

#import <AVFoundation/AVFoundation.h>
#import "CCCustomerServiceView.h"

#import "CCWebViewController.h"

@implementation CCAppSettingManager



+(void)appSetting{
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    [self tabBarViewControllerSetting];
    [self pushHomeController];
    [AppDelegate sharedApplicationDelegate].userInfoModel = [CCUserInfoModel UserInfoObtain];
    [AppDelegate sharedApplicationDelegate].fileConfigurationModel = [CCFileConfigurationModel FileConfigurationObtain];
    
    if ([AppDelegate sharedApplicationDelegate].userInfoModel) {
        [self userStartSignIn];
    }
    //获取木配制文件
    [self getConfigurationFile];
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    if (![@"YES" isEqualToString:[userDefaults objectForKey:@"isShowScrollView"]]) {
//        [self welcomeViewController];
//        [userDefaults setObject:@"YES" forKey:@"isShowScrollView"];
//    }else {
//        [self pushHomeController];
//    }
}

+(void)pushHomeController{
    TabBarController * tabbar = [[TabBarController alloc]init];
    [CYTabBarConfig shared].selectedTextColor = MCUIColorMain;
    [CYTabBarConfig shared].textColor = [UIColor grayColor];
    [CYTabBarConfig shared].backgroundColor = [UIColor whiteColor];
    [CYTabBarConfig shared].selectIndex = 0;
    [CYTabBarConfig shared].centerBtnIndex = 2;
    [CYTabBarConfig shared].HidesBottomBarWhenPushedOption = HidesBottomBarWhenPushedAlone;
    [self style1:tabbar];
    
    [AppDelegate sharedApplicationDelegate].window.rootViewController = tabbar;
}

+(void)style1:(CYTabBarController *)tabbar {
    CCNavigationController *homeNav = [[CCNavigationController alloc]initWithRootViewController:[[CCLiveViewController alloc] init]];
    [tabbar addChildController:homeNav title:@"直播" imageName:@"直播-未选中" selectedImageName:@"直播-选中"];
    
    CCNavigationController *monographicNav = [[CCNavigationController alloc]initWithRootViewController:[[CCBroadcastViewController alloc] init]];
    [tabbar addChildController:monographicNav title:@"云播" imageName:@"云播-未选中" selectedImageName:@"云播-选中"];
    
    CCWebViewController *lotteryVC = [[CCWebViewController alloc]init];
    lotteryVC.urlString = @"http://www.167k3.com";
    lotteryVC.webViewType = WebViewTypeLottery;
    lotteryVC.titleString = @"彩票";
    
    CCNavigationController *lotteryNav = [[CCNavigationController alloc]initWithRootViewController:lotteryVC];
    [tabbar addChildController:lotteryNav title:@"彩票" imageName:@"彩票-未选中" selectedImageName:@"彩票-选中"];

    
    CCNavigationController *findViewNav = [[CCNavigationController alloc]initWithRootViewController:[[CCWelfareViewController alloc]init]];
    [tabbar addChildController:findViewNav title:@"福利" imageName:@"福利-未选中" selectedImageName:@"福利-选中"];
    
    CCNavigationController *mineNav = [[CCNavigationController alloc]initWithRootViewController:[[CCMineViewController alloc]init]];
    [tabbar addChildController:mineNav title:@"我的" imageName:@"我的-未选中" selectedImageName:@"我的-选中"];
}

+(void)welcomeViewController{
    DWIntrosPageContentViewController *page1 = [DWIntrosPageContentViewController introsPageWithBackgroundImage:[UIImage imageNamed:@"引导页1"]];
    DWIntrosPageContentViewController *page2 = [DWIntrosPageContentViewController introsPageWithBackgroundImageWithName:@"引导页2"];
    DWIntrosPageContentViewController *page3 = [DWIntrosPageContentViewController introsPageWithBackgroundImageWithName:@"引导页3"];
    DWIntrosPagesViewController *introsPage = [DWIntrosPagesViewController dwIntrosPagesWithPageArray:@[page1, page2, page3]];
    //    introsPage.showPageControl = YES; //show the pageControl
    //    introsPage.canSkip = YES; // show the skipButton
    //    introsPage.skipButton.backgroundColor = [UIColor redColor]; //setup the skipButton
    __weak typeof(self) weakSelf = self;
    [AppDelegate sharedApplicationDelegate].window.rootViewController = introsPage;
    introsPage.skipButtonClickedBlock = ^{
        [weakSelf pushHomeController];
    };
}


+(void)tabBarViewControllerSetting{
    UIImageView *lunchImageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    lunchImageView.image = [self getLaunchImage];
    UIViewController *vc = [UIViewController new];
    [vc.view addSubview:lunchImageView];
    [AppDelegate sharedApplicationDelegate].window.rootViewController = vc;
}

+ (UIImage *)getLaunchImage{
    NSString *viewOrientation = @"Portrait";
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        viewOrientation = @"Landscape";
    }
    NSString *launchImageName = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    UIWindow *currentWindow = [[UIApplication sharedApplication].windows firstObject];
    CGSize viewSize = currentWindow.bounds.size;
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    return [UIImage imageNamed:launchImageName];
}


#pragma 用户签到
+(void)userStartSignIn{
    [CCMineManage MineStartSignInCompletion:^(id resultDictionary, NSError *error) {}];
}

#pragma 获取配置文件
+(void)getConfigurationFile{
    [CCMineManage MineConfigurationFileCompletion:^(id resultDictionary, NSError *error) {
        if (!error) {
            NSString *code = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"code"]];
            if ([code isEqualToString:@"1000"]) {
                NSDictionary *cfdic = [resultDictionary objectForKey:@"data"];
                if (cfdic) {
                    [CCFileConfigurationModel FileConfigurationWithObject:cfdic];
                    CCFileConfigurationModel *model = [CCFileConfigurationModel modelWithDictionary:cfdic];
                    [AppDelegate sharedApplicationDelegate].fileConfigurationModel = model;
                    
                    if ([AppDelegate sharedApplicationDelegate].fileConfigurationModel.sites.maintain_tips.length != 0) {
                        CCCustomerServiceView *customerServiceView = [[CCCustomerServiceView alloc]init];
                        [[AppDelegate sharedApplicationDelegate].window addSubview:customerServiceView];
                        customerServiceView.viewMessageString = [AppDelegate sharedApplicationDelegate].fileConfigurationModel.sites.maintain_tips;
                        [customerServiceView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.edges.equalTo([AppDelegate sharedApplicationDelegate].window);
                        }];
                    }
                    if ([AppDelegate sharedApplicationDelegate].fileConfigurationModel.updates.ipa_ver.length != 0) {
                        if ([self compareVesionWithServerVersion:[AppDelegate sharedApplicationDelegate].fileConfigurationModel.updates.ipa_ver]) {
                            [self updatedVersion];
                        }
                    }
                }else{
                    [AppDelegate sharedApplicationDelegate].fileConfigurationModel = [CCFileConfigurationModel FileConfigurationObtain];
                }
            }else{
                [AppDelegate sharedApplicationDelegate].fileConfigurationModel = [CCFileConfigurationModel FileConfigurationObtain];
            }
        }else{
            [AppDelegate sharedApplicationDelegate].fileConfigurationModel = [CCFileConfigurationModel FileConfigurationObtain];
        }
    }];
}

+(BOOL)compareVesionWithServerVersion:(NSString *)version{
    NSArray *versionArray = [version componentsSeparatedByString:@"."];//服务器返回版
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSArray *currentVesionArray = [app_Version componentsSeparatedByString:@"."];//当前版本
    NSInteger a = (versionArray.count> currentVesionArray.count)?currentVesionArray.count : versionArray.count;
    for (int i = 0; i< a; i ++) {
        NSInteger a = [[versionArray objectAtIndex:i] integerValue];
        NSInteger b = [[currentVesionArray objectAtIndex:i] integerValue];
        if (a > b) {
            return YES;
        }else if(a < b){
            return NO;
        }
    }
    return NO;
}

#pragma 更新版本
+(void)updatedVersion{
    UIViewController *viewCTL = [[UIViewController alloc]init];
    [[AppDelegate sharedApplicationDelegate].window addSubview:viewCTL.view];

    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"重要提示" message:@"「大黄鸭」有新的版本，是否去更新？" preferredStyle:UIAlertControllerStyleAlert];//
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [viewCTL.view removeFromSuperview];
    }];;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[AppDelegate sharedApplicationDelegate].fileConfigurationModel.updates.ipa_url]]];
        [viewCTL.view removeFromSuperview];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [viewCTL presentViewController:alertController animated:YES completion:nil];
}

@end
