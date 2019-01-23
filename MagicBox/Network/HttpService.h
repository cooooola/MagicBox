//
//  HttpService.h
//  rainbow-core
//
//  Created by Franklin Zhang on 9/13/14.
//  Copyright (c) 2014 Macrame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit+AFNetworking.h"
#import "AFNetworking.h"

#define HOSTADDRESS   @"http://api.wbawh.cn/"

typedef enum{
    HttpMethodGet = 1,
    HttpMethodPost = 2,
    HttpMethodPut = 3,
    HttpMethodDelete = 4
} HttpMethod;

typedef enum{
    FileTypeImge = 1,
    FileTypeVoice = 2,
    FileTypeVideo = 3,
} FileType;

@interface HttpService : AFHTTPSessionManager

/**
 初始化请求

 @return 请求单例
 */
+ (instancetype) sharedService;

/**
 GET请求

 @param parameter 参数
 @param path 路径
 @param completion 数据返回
 */
- (void)getRequest:(NSMutableDictionary *)parameter withPath:(NSString *)path completion:(void(^) (id resultDictionary, NSError *error)) completion;

/**
 POST请求

 @param parameter 参数
 @param path 路径
 @param completion 数据返回
 */
- (void)postRequest:(id)parameter withPath:(NSString *)path completion:(void(^) (id resultDictionary, NSError *error)) completion;


/**
 所有请求

 @param parameter 参数
 @param path 路径
 @param completion 数据返回
 @param httpMethod 请求方式
 */
- (void)request:(NSMutableDictionary *)parameter withPath:(NSString *)path  completion:(void(^) (id resultDictionary, NSError *error)) completion withMethod:(HttpMethod) httpMethod;

/**
 上传文件

 @param parameter 参数
 @param fullpath 路径
 @param completion 数据返回
 @param attachments 上传数据
 */
- (void)appendAttachmentRequest:(NSMutableDictionary *)parameter withFullPath:(NSString *)fullpath completion:(void(^) (id resultDictionary, NSError *error)) completion appendAttachment:(NSData *)attachments andFileType:(FileType)fileType andPathName:(NSString *)pathName;



@end
