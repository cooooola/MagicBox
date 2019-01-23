//
//  CCNavigationController.m
//  SchoolMakeUp
//
//  Created by goulela on 16/9/26.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "CCNavigationController.h"

@interface CCNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation CCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar * navigationBar = [UINavigationBar appearance];
    [navigationBar setTitleTextAttributes:@{NSFontAttributeName : MCFont(19.0f),NSForegroundColorAttributeName :MCUIColorFromRGB(0x000000)}];
    navigationBar.translucent = NO;
    [navigationBar setBackgroundImage:[CCTool imageWithColor:MCUIColorMain] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[CCTool imageWithColor:[UIColor clearColor]]];
    self.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        if (self.viewControllers.count < 2) {
            return NO;
        }
    }
    return YES;
}

@end
