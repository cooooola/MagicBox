//
//  UIImage+image.m
//  BuBuBa
//
//  Created by goulela on 16/5/18.
//  Copyright © 2016年 bububa. All rights reserved.
//

#import "UIImage+image.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@interface View : UIView
@property (nonatomic, strong) UIImage * image;
@end

@implementation View

- (void)drawRect:(CGRect)rect {
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(contextRef);
    
    // Ellipse --> 椭圆的
    CGContextAddEllipseInRect(contextRef, CGRectMake(0, 0, rect.size.width, rect.size.height));
    CGContextClip(contextRef);
    CGContextFillPath(contextRef);
    [self.image drawAtPoint:CGPointMake(0, 0)];
    
    CGContextRestoreGState(contextRef);
}
@end


@implementation UIImage (image)

+ (instancetype)imageWithOriginalName:(NSString *)imageName
{
    UIImage * image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


// 裁切图片
- (UIImage *)imageCutSize:(CGRect)rect {

    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallRect = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallRect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextDrawImage(context, smallRect, subImageRef);
    UIImage * image = [UIImage imageWithCGImage:subImageRef];
    
    UIGraphicsEndImageContext();
    
    return image;
}

// 图片旋转
- (UIImage *)imageRotaTeIndegree:(CGFloat)degree {

    size_t width = (size_t)(self.size.width * self.scale);
    size_t height = (size_t)(self.size.height * self.scale);
    
    size_t bytesPerRow = width * 4;
    CGImageAlphaInfo alphaInfo = kCGImageAlphaPremultipliedFirst;
    
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, bytesPerRow, CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrderDefault | alphaInfo);
    
    if (!bmContext) {
        return nil;
    }
    
    CGContextDrawImage(bmContext, CGRectMake(0, 0, width, height), self.CGImage);
    
    // 旋转
    UInt8 * data = (UInt8 *)CGBitmapContextGetData(bmContext);
    vImage_Buffer src = {data,height,width,bytesPerRow};
    vImage_Buffer dest = {data,height,width,bytesPerRow};
    
    Pixel_8888 bgColor = {0,0,0,0};
    
    vImageRotate_ARGB8888(&src, &dest, NULL, degree, bgColor, kvImageBackgroundColorFill);
    
    // 3 转换为Image
    CGImageRef rotateImageRef = CGBitmapContextCreateImage(bmContext);
    UIImage * rotateImage = [UIImage imageWithCGImage:rotateImageRef scale:self.scale orientation:self.imageOrientation];
    
    return rotateImage;
}

- (UIImage *)imageWater:(UIImage *)imageLogo waterString:(NSString *)waterString withScale:(CGFloat)scale{
    
    UIGraphicsBeginImageContext(self.size);
    // 原始图片渲染
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    CGFloat waterWH = self.size.width / scale;
    CGFloat waterX = (self.size.width - waterWH) / 2;
    CGFloat waterY = (self.size.width - waterWH) / 2;
    
    // logo 渲染
    [imageLogo drawInRect:CGRectMake(waterX, waterY, waterWH, waterWH)];
    
    
    UIGraphicsEndPDFContext();
    
    // UIImage
    UIImage * imageNew = UIGraphicsGetImageFromCurrentImageContext();
    
    return imageNew;
}

- (UIImage *)imageClicpCircleWithRect:(CGRect)rect {
    
    View * myView = [[View alloc] init];
    myView.image = self;
    myView.layer.masksToBounds = YES;
    myView.layer.cornerRadius = rect.size.width / 2;
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    myView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    myView.backgroundColor = [UIColor whiteColor];
    [myView.layer renderInContext:context];
    
    UIImage * imageNew = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageNew;
}


@end
