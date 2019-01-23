//
//  CCView.m
//  BuBuBa
//
//  Created by goulela on 16/5/20.
//  Copyright © 2016年 bububa. All rights reserved.
//

#import "CCView.h"

@implementation CCView

// 背景视图的宽度/高度
#define BGVIEW_WIDTH 100.0f
// 文字大小
#define TEXT_SIZE    16.0f

#pragma mark - UI相关
// 添加左右元素项
+ (void)BSBarButtonItem_image_Who:(UINavigationItem *)navigationItem size:(CGSize)size target:(id)target selected:(SEL)selector image:(NSString *)image isLeft:(NSInteger)isLeft {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, size.width, size.height);
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenHighlighted = NO;
    if (isLeft == YES) {
        navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    } else {
        navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}

+ (void)BSBarButtonItem_text_who:(UINavigationItem *)navigationItem size:(CGSize)size target:(id)target selected:(SEL)selector textColor:(UIColor *)color font:(CGFloat)font andText:(NSString *)text isLeft:(NSInteger)isLeft {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, size.width, size.height);
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.titleLabel.font = MCFont(font);
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenHighlighted = NO;
    if (isLeft == 0) {
        navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    } else {
        navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}



#pragma mark - MBProgressHUD
+ (void)BSMBProgressHUD_onlyTextWithView:(UIView *)view andText:(NSString * )text {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    if (text.length == 0) {
        [HUD hideAnimated:YES];
        return;
    }
    HUD.contentColor = [UIColor whiteColor];
    HUD.bezelView.color = [UIColor blackColor];
    HUD.mode = MBProgressHUDModeText;
    HUD.label.text = text;
    HUD.label.numberOfLines = 0;
    HUD.removeFromSuperViewOnHide = YES;
    [view addSubview:HUD];
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1.5];
}

+ (void)BSMBProgressHUD_bufferAndTextWithView:(UIView *)view andText:(NSString * )text {
    
    if (text == nil) {
        text = @"正在加载";
    }
    MBProgressHUD *HUD=[[MBProgressHUD alloc]initWithView:view];
    HUD.backgroundView.color = [UIColor colorWithWhite:0.f alpha:.2f];
    HUD.bezelView.color = [UIColor blackColor];
    HUD.contentColor=[UIColor whiteColor];
    HUD.label.text=text;
    HUD.removeFromSuperViewOnHide=YES;
    [view addSubview:HUD];
    [HUD bringSubviewToFront:view];
    [HUD showAnimated:YES];
}
+ (void)BSMBProgressHUD_hideWith:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+ (void)BSMBProgressHUD_customWithView:(UIView *)view andImage:(NSString *)image andText:(NSString *)text {
    
    if (text.length == 0) { text = @"处理中";}
    if (image.length == 0) { image = @"MBHUD_Success";}
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.bezelView.color = [UIColor blackColor];
    HUD.contentColor=[UIColor whiteColor];
    [HUD showAnimated:YES];
    HUD.label.textColor = [UIColor whiteColor];
    
    HUD.label.text = text;
    [HUD setRemoveFromSuperViewOnHide:YES];
    HUD.label.font = [UIFont boldSystemFontOfSize:TEXT_SIZE];
    [HUD setMinSize:CGSizeMake(BGVIEW_WIDTH, BGVIEW_WIDTH)];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = imageView;
        HUD.square = YES;
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.label.text = @"完成";
        
        [HUD showAnimated:YES];
        [HUD hideAnimated:YES afterDelay:1.5];
    });
}

#pragma mark - UIAlertController
+ (void)BSAlertController_twoOptions_viewController:(UIViewController *)viewController message:(NSString *)message confirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle confirm:(void (^)())confirm cancle:(void (^)())cancle {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        cancle();
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        confirm();
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

+ (void)BSAlertController_oneOption_viewController:(UIViewController *)viewController message:(NSString *)message cancle:(void (^)())cancle {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (cancle) {
            cancle();
        }
    }];
    [alertController addAction:cancelAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

+ (void)BSAlertController_abnormalNetwork_viewController:(UIViewController *)viewController {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Sorry,网络开了个小差" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - 页面跳转封装
// 跳转到登录
+ (void)BSJumpTo_loginViewController:(UIViewController *)viewController {
//    KKLoginViewController * login = [[KKLoginViewController alloc] init];
//    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:login];
//    [viewController presentViewController:nav animated:YES completion:nil];
}

@end
