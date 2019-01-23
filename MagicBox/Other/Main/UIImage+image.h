//
//  UIImage+image.h
//  BuBuBa
//
//  Created by goulela on 16/5/18.
//  Copyright © 2016年 bububa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (image)

+ (instancetype)imageWithOriginalName:(NSString *)imageName;


- (UIImage *)imageCutSize:(CGRect)rect;

- (UIImage *)imageRotaTeIndegree:(CGFloat)degree;

- (UIImage *)imageWater:(UIImage *)imageLogo waterString:(NSString *)waterString withScale:(CGFloat)scale;

- (UIImage *)imageClicpCircleWithRect:(CGRect)rect;

@end
