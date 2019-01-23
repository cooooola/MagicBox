//
//  CCTool.m
//  BuBuBa
//
//  Created by goulela on 16/5/19.
//  Copyright © 2016年 bububa. All rights reserved.
//

#import "CCTool.h"
#import <sys/utsname.h>

@implementation CCTool

+(NSString *)getAppIconName{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSArray *iconsArr = infoDict[@"CFBundleIcons"][@"CFBundlePrimaryIcon"][@"CFBundleIconFiles"];
    NSString *iconLastName = [iconsArr lastObject];
    return iconLastName;
}

#pragma mark - 用户信息
+ (NSString *)getDevice {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if([platform isEqualToString:@"iPhone5,2"])
    return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"])
    return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"])
    return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"])
    return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"])
    return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"])
    return@"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])
    return@"iPhone 6,6s,7,8";
    
    if([platform isEqualToString:@"iPhone8,1"])
    return@"iPhone 6,6s,7,8";
    
    if([platform isEqualToString:@"iPhone8,2"])
    return@"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"])
    return@"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"])
    return@"iPhone 6,6s,7,8";
    
    if([platform isEqualToString:@"iPhone9,2"])
    return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"])
    return@"iPhone 6,6s,7,8";
    
    if([platform isEqualToString:@"iPhone10,4"])
    return@"iPhone 6,6s,7,8";
    
    if([platform isEqualToString:@"iPhone10,2"])
    return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"])
    return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"])
    return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"])
    return@"iPhone X";
    
    return @"模拟器";
}


#pragma mark - 返回颜色图片
+(UIImage*)imageWithColor:(UIColor*)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



// 获取当前的视图的view,给MBProgressHUD当父视图
+ (UIView *)BSGetCurrentViewWith:(UIViewController *)viewController {
    UIView *view;
    if (viewController == nil) {
        view = viewController.navigationController.view;
    } else {
        view=viewController.view;
    } return view;
}


// 获取网络图片
+ (UIImage *)BSImage_createFromURL:(NSString *)fileURL {
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    UIImage * result = [UIImage imageWithData:data];
    return result;
}


#pragma mark - 文字的处理
+ (NSAttributedString *)BSNSAttributedString_fontAndColorWithColorRange:(NSRange)colorRange fontRange:(NSRange)fontRange color:(UIColor *)color font:(CGFloat)font text:(NSString * )text {
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:fontRange];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:colorRange];
    return attributedString;
}

+ (NSAttributedString *)BSNSAttributedString_deleteLineWithLineColor:(UIColor *)color Text:(NSString * )text {
    NSRange range = NSMakeRange(0, text.length);
    UIColor * deleteLineColor = color;
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(0, text.length)];
    [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:range];
    [attributedString addAttribute:NSStrikethroughColorAttributeName value:deleteLineColor range:range];
    return attributedString;
}

+ (NSString *)BSNSString_cutOutFromZeroPositionWithLength:(NSInteger)length andText:(NSString *)text {
    if (text.length > length) {
        return [text substringToIndex:length];
    } else {
        return text;
    }
}

#pragma mark - 判断处理
// 判断手机号是否正确
+ (BOOL)BSJudge_phoneNumber:(NSString *)phoneNum {
    NSString *regex = @"^1[3|4|5|6|7|8][0-9]{9}$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isValid = [pre evaluateWithObject:phoneNum];
    
    BOOL result;
    if (isValid) {
        NSInteger length = phoneNum.length;
        if (length == 11) {
            result = YES;
        } else {
            result = NO;
        }
    } else {
        result = NO;
    } return result;
}
// 判断账号
+ (BOOL)BSJudge_accountWith:(NSString *)account {
    if (account.length <= 0) {
        return NO;
    }
    NSString * regex = @"^[A-Za-z0-9]{1,15}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:account];
    return isMatch;
}



+ (UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows){
            if (tmpWin.windowLevel == UIWindowLevelNormal){
                window = tmpWin;
                break;}
        }
    }

    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        if([nextResponder isKindOfClass:[UITabBarController class]]){
            result = ((UITabBarController*)nextResponder).selectedViewController;
            if([result isKindOfClass:[UINavigationController class]]){
                result = ((UINavigationController*)result).visibleViewController;
            }
        }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
            result = ((UINavigationController*)nextResponder).visibleViewController;
        }else{
            result = nextResponder;
        }
    }else{
        result = window.rootViewController;
    }
    return result;
}

/**
 
  *  通过 CAShapeLayer方式绘制虚线
 
  *
 
  *  param lineView:       需要绘制成虚线的view
 
  *  param lineLength:     虚线的宽度
 
  *  param lineSpacing:    虚线的间距
 
  *  param lineColor:      虚线的颜色
 
  **/

+(void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame)/2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    [shapeLayer setStrokeColor:lineColor.CGColor];
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing],nil]];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL, 0,0);
    CGPathAddLineToPoint(path,NULL,CGRectGetWidth(lineView.frame),0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    [lineView.layer addSublayer:shapeLayer];
}
@end
