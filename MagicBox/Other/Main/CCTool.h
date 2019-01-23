//
//  CCTool.h
//  BuBuBa
//
//  Created by goulela on 16/5/19.
//  Copyright © 2016年 bububa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^SuccessBlock)(id data);
typedef void(^DislikeBlock)(id data);
typedef void(^FailureBlock)(NSError * error);
typedef void(^ErrorMessageDealBlock)(id data);
typedef void(^CodeImageSuccessBlock)(id data);

@interface CCTool : NSObject

//获取app图标
+(NSString *)getAppIconName;


#pragma mark - 返回颜色图片
+(UIImage*)imageWithColor:(UIColor*)color;

+ (UIImage *)BSImage_createFromURL:(NSString *)fileURL;



#pragma mark - 字符串
+ (NSAttributedString *)BSNSAttributedString_fontAndColorWithColorRange:(NSRange)colorRange fontRange:(NSRange)fontRange color:(UIColor *)color font:(CGFloat)font text:(NSString * )text;
+ (NSAttributedString *)BSNSAttributedString_deleteLineWithLineColor:(UIColor *)color Text:(NSString * )text;
+ (NSString *)BSNSString_cutOutFromZeroPositionWithLength:(NSInteger)length andText:(NSString *)text;

#pragma mark - 判断
+ (BOOL)BSJudge_phoneNumber:(NSString *)phoneNum;
// 判断账号是否正确
+ (BOOL)BSJudge_accountWith:(NSString *)userName;
// 是否登录
+ (BOOL)BSJudge_userIsLoginWith:(UIViewController *)vc;

+ (UIViewController *)getCurrentVC;

#pragma mark - 系统

+ (NSMutableArray *)getIAPsBundleId;


/**
 绘制虚线

 @param lineView 绘制成虚线的view
 @param lineLength 虚线的宽度
 @param lineSpacing 虚线的间距
 @param lineColor 虚线的颜色
 */
+(void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

@end
