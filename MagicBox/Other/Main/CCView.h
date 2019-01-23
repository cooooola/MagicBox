//
//  CCView.h
//  BuBuBa
//
//  Created by goulela on 18/9/18.
//  Copyright © 2018年 bububa. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBProgressHUD.h"

@interface CCView : NSObject



#pragma mark UI
+ (void)BSBarButtonItem_image_Who:(UINavigationItem *)navigationItem size:(CGSize)size target:(id)target selected:(SEL)selector image:(NSString *)image isLeft:(NSInteger)isLeft;
+ (void)BSBarButtonItem_text_who:(UINavigationItem *)navigationItem size:(CGSize)size target:(id)target selected:(SEL)selector textColor:(UIColor *)color font:(CGFloat)font andText:(NSString *)text isLeft:(NSInteger)isLeft;

#pragma mark - MBProgressHUD
+ (void)BSMBProgressHUD_onlyTextWithView:(UIView *)view andText:(NSString * )text;
+ (void)BSMBProgressHUD_bufferAndTextWithView:(UIView *)view andText:(NSString * )text;
+ (void)BSMBProgressHUD_hideWith:(UIView *)view;
+ (void)BSMBProgressHUD_customWithView:(UIView *)view andImage:(NSString *)image andText:(NSString *)text;


#pragma mark - UIAlertController
+ (void)BSAlertController_twoOptions_viewController:(UIViewController *)viewController message:(NSString *)message confirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle  confirm:(void (^)())confirm cancle:(void (^)())cancle;
+ (void)BSAlertController_oneOption_viewController:(UIViewController *)viewController message:(NSString *)message cancle:(void(^)())cancle;
+ (void)BSAlertController_abnormalNetwork_viewController:(UIViewController *)viewController;


#pragma mark - 页面跳转封装
// 跳转到登录
+ (void)BSJumpTo_loginViewController:(UIViewController *)viewController;

@end
