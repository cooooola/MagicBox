//
//  CCCleanCacheManager.h
//  Kingkong_ios
//
//  Created by hello on 2018/4/30.
//  Copyright © 2018年 MC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^cleanCacheBlock)(void);

@interface CCCleanCacheManager : NSObject

/**
 *  清理缓存
 */
+(void)cleanCache:(cleanCacheBlock)block;
/**
 *  整个缓存目录的大小
 */
+(float)folderSizeAtPath;

@end
