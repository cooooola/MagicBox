//
//  HttpService.m
//  rainbow-core
//
//  Created by Franklin Zhang on 9/13/14.
//  Copyright (c) 2014 Macrame. All rights reserved.
//



#import "HttpService.h"
#import "CCJsonTool.h"
#import "AppDelegate.h"

@implementation HttpService

+ (instancetype) sharedService{
    static HttpService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[HttpService alloc] init];
        service.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/plain",@"text/html",nil];//接受包含结果类型
        service.requestSerializer = [AFHTTPRequestSerializer serializer];
        service.responseSerializer = [AFHTTPResponseSerializer serializer];
//        service.requestSerializer  = [AFJSONRequestSerializer serializer];//申明请求结果为JSON类型
//        [service.requestSerializer setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [service.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        service.requestSerializer.timeoutInterval = 20.0f;
        [service.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    });
    return service;
}
//GET请求
- (void)getRequest:(NSMutableDictionary *)parameter withPath:(NSString *)path completion:(void(^) (id resultDictionary, NSError *error)) completion{
    [self request:parameter withPath:path targetClass:nil completion:completion withMethod:HttpMethodGet appendAttachment:nil];
}

//POST请求
- (void)postRequest:(id)parameter withPath:(NSString *)path completion:(void(^) (id resultDictionary, NSError *error)) completion{
    [self request:parameter withPath:path targetClass:nil completion:completion withMethod:HttpMethodPost appendAttachment:nil];
}

//所有请求
- (void)request:(NSMutableDictionary *)parameter withPath:(NSString *)path  completion:(void(^) (id resultDictionary, NSError *error)) completion withMethod:(HttpMethod) httpMethod{
    [self request:parameter withPath:path targetClass:nil completion:completion withMethod:httpMethod appendAttachment:nil];
}

////数据上传
//- (void)appendAttachmentRequest:(NSMutableDictionary *)parameter withPath:(NSString *)path completion:(void(^) (id resultDictionary, NSError *error)) completion appendAttachment:(NSDictionary *)attachments{
//    [self request:parameter withFullPath:path targetClass:[NSDictionary class] completion:completion withMethod:HttpMethodPost appendAttachment:attachments];
//}


- (void) request:(id)parameter withPath:(NSString *)path targetClass:(Class)classType completion:(void(^) (id resultDictionary, NSError *error)) completion withMethod:(HttpMethod) httpMethod appendAttachment:(NSDictionary *)attachments{
    [self request:parameter withFullPath:path targetClass:[NSDictionary class] completion:completion withMethod:httpMethod appendAttachment:attachments];
}

- (void) request:(id)parameter withFullPath:(NSString *)fullpath targetClass:(Class)classType completion:(void(^) (id resultDictionary, NSError *error)) completion withMethod:(HttpMethod) httpMethod appendAttachment:(NSDictionary *)attachments{
    NSString *requestUrl;
    if([fullpath containsString:@"http"]) {
        requestUrl = [NSString stringWithFormat:@"%@",fullpath];
    }else{
        requestUrl = [NSString stringWithFormat:@"%@%@",HOSTADDRESS,fullpath];
    }
    if(parameter != nil){
        void (^successBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
            id responseJson = [CCJsonTool JsonToolWithDataConvertedJsonWhitData:responseObject];
            completion(responseJson,nil);
        };
        void (^failureBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, NSError *error) {
            completion(nil, error);
        };
        if(httpMethod == HttpMethodPost){
            [self POST:requestUrl parameters:parameter progress:nil success:successBlock failure:failureBlock];
        }else if (httpMethod == HttpMethodPut){
            [self PUT:requestUrl parameters:parameter success:successBlock failure:failureBlock];
        }else if (httpMethod == HttpMethodDelete){
            [self DELETE:requestUrl parameters:parameter success:successBlock failure:failureBlock];
        }else{
            [self GET:requestUrl parameters:parameter progress:nil success:successBlock failure:failureBlock];
        }
    }
}


//上传文件
- (void)appendAttachmentRequest:(NSMutableDictionary *)parameter withFullPath:(NSString *)fullpath completion:(void(^) (id resultDictionary, NSError *error)) completion appendAttachment:(NSData *)attachments andFileType:(FileType)fileType andPathName:(NSString *)pathName{
//    if ([AppDelegate sharedApplicationDelegate].UserInfoModel) {
//        [self.requestSerializer setValue:[NSString stringWithFormat:@"Bearer_%@",[AppDelegate sharedApplicationDelegate].UserInfoModel.token] forHTTPHeaderField:@"Authorization"];
//    }
//    if(fullpath == nil){
//        NSError *error = [NSError errorWithDomain:@"macrame" code:201 userInfo:@{NSLocalizedDescriptionKey:@"url is null"}];
//        completion(nil,error);
//        return;
//    }
    
//    if (attachments == nil) {
//        NSError *error = [NSError errorWithDomain:@"macrame" code:201 userInfo:@{NSLocalizedDescriptionKey:@"data is null"}];
//        completion(nil,error);
//        return;
//    }
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@",HOSTADDRESS];
    if(parameter != nil){
        void (^successBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
            completion(responseObject,nil);
        };
        
        void (^failureBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, NSError *error) {
            completion(nil, error);
        };
        
        [self POST:requestUrl parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            if(fileType == FileTypeImge){
                [formData appendPartWithFileData:attachments name:pathName fileName:[[self getFileNameWithCurrentTimes] stringByAppendingString:@".png"] mimeType:@"image/png"];
            }else{
                [formData appendPartWithFileData:attachments name:pathName fileName:[[self getFileNameWithCurrentTimes] stringByAppendingString:@".caf"] mimeType:@"application/octet-stream"];
            }
        } progress:nil success:successBlock failure:failureBlock];
    }
}

//设置文件名称
-(NSString*)getFileNameWithCurrentTimes{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmssSS"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}

@end
