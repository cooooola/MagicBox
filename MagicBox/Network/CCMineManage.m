//
//  CCMineManage.m
//  KitchenAlwaysOnline
//
//  Created by hello on 2018/9/14.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCMineManage.h"
#import "HttpService.h"
#import "AppDelegate.h"
#import "CCJsonTool.h"
#import "CCLoginViewController.h"
#import "CCMineMemberRrenewalViewController.h"

//广告
static NSString * const apiConfigurationFile = @"config/config";
static NSString * const apiMemberInspection = @"user/checkexp";
static NSString * const apiPreview = @"user/preview";//试用

//用户管理
static NSString * const apiStartSignIn = @"config/active";//签到
static NSString * const apiVerificationCode = @"user/sendcode";//手机验证码
static NSString * const apiRegister = @"user/reg";//注册
static NSString * const apiLogin = @"user/logins";//登陆
static NSString * const apiUserInfo = @"user/userinfo";//会员信息
static NSString * const apiChangepwd = @"user/changepwd";//修改密码

//积分
static NSString * const apiInquireIntegral = @"reward/integral";//会员信息
static NSString * const apiDownloadRecord = @"reward/queryuv";//下载记录
static NSString * const apiRegistrationRecord = @"reward/queryreg";//注册记录
static NSString * const apiRedeemPoints = @"reward/exchange";//兑换积分

//小说
static NSString * const apiFictionClassification = @"reader/getclass";//小说分类
static NSString * const apiFictionList = @"reader/getlist";//小说列表
static NSString * const apiFictionContent = @"reader/read";//小说内容

//图片
static NSString * const apiImageClassification = @"images/getclass";//图片分类
static NSString * const apiImageList = @"images/getlist";//图片列表
static NSString * const apiImageContent = @"images/view";//图片内容




//直播
static NSString * const apiLivePlatform = @"live/getsite";//直播平台
static NSString * const apiPlatformData = @"live/getpt";//平台数据
static NSString * const apiPronHhub = @"hub/getclass";//PronHhub
static NSString * const apiHubList = @"hub/getlist";//PronHhub播放列表
static NSString * const apiHubPlay = @"hub/play";//PronHhub播放


static NSString * const apiXhgdy = @"xhgdy/getclass";//小黄瓜影院
static NSString * const apiXhgdyList = @"xhgdy/getlist";//小黄瓜影院播放列表
static NSString * const apiXhgdyPlay = @"xhgdy/play";//小黄瓜影院播放

static NSString * const apiAVdy = @"av/getclass";//av影院
static NSString * const apiAVdyList = @"av/getlist";//av影院
static NSString * const apiAVdyPlay = @"av/play";//av影院

//代理
static NSString * const apiAgentContact = @"card/agent";//代理联系方式
static NSString * const apiCardExchange = @"card/exchange";//卡密兑换



@implementation CCMineManage

//获取配置文件
+(void)MineConfigurationFileCompletion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiConfigurationFile completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}

//会员检测
+(void)MineMemberInspectionWithViewController:(UIViewController *)viewController Completion:(void(^) (BOOL MemberStatus)) completion{
    NSString *mobile = [AppDelegate sharedApplicationDelegate].userInfoModel.user_login;
    if (mobile.length == 0) {
        [self MinePreviewWithViewController:viewController Completion:^(BOOL PreviewStatus) {
            completion(PreviewStatus);
        }];
//        [self MinePreviewCompletion:^(BOOL PreviewStatus) {
//
//        }];
    }else{
        [CCView BSMBProgressHUD_bufferAndTextWithView:[AppDelegate sharedApplicationDelegate].window andText:@"会员检测中，请稍候..."];
        NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
        [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
        [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
        [parameterDictionary setObject:[AppDelegate sharedApplicationDelegate].userInfoModel.user_login forKey:@"mobile"];
        [parameterDictionary setObject:mobile forKey:@"mobile"];
        [parameterDictionary setObject:[CCJsonTool JsonToolUniqueAppInstanceIdentifier] forKey:@"imie"];
        HttpService *service = [HttpService sharedService];
        [service getRequest:parameterDictionary withPath:apiMemberInspection completion:^(id resultDictionary, NSError *error) {
            [CCView BSMBProgressHUD_hideWith:[AppDelegate sharedApplicationDelegate].window];
            if (error) {
                [CCView BSMBProgressHUD_onlyTextWithView:[AppDelegate sharedApplicationDelegate].window andText:@"网络错误，请稍候再试！"];
                completion(NO);
            }else{
                NSString *result = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"result"]];
                NSString *msg = [resultDictionary objectForKey:@"msg"];
                if ([result isEqualToString:@"1000"]) {
                    completion(YES);
                }else{
                    if ([result isEqualToString:@"1001"]) {
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"重要提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            CCMineMemberRrenewalViewController *mrvc = [[CCMineMemberRrenewalViewController alloc]init];
                            [viewController.navigationController pushViewController:mrvc animated:YES];
                        }]];
                        [viewController presentViewController:alert animated:true completion:nil];
                        
                    }else{
                        [CCView BSMBProgressHUD_onlyTextWithView:[AppDelegate sharedApplicationDelegate].window andText:msg];
                    }
//                    [CCView BSMBProgressHUD_onlyTextWithView:[AppDelegate sharedApplicationDelegate].window andText:msg];
                    completion(NO);
                }
            }
        }];
    }
}

//未注册登录串号检测
+(void)MinePreviewWithViewController:(UIViewController *)viewController Completion:(void(^) (BOOL PreviewStatus)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    [parameterDictionary setObject:[CCJsonTool JsonToolUniqueAppInstanceIdentifier] forKey:@"imie"];
    
    HttpService *service = [HttpService sharedService];
    [CCView BSMBProgressHUD_bufferAndTextWithView:[AppDelegate sharedApplicationDelegate].window andText:@"当前未登录，试看机会查询中..."];
    [service getRequest:parameterDictionary withPath:apiPreview completion:^(id resultDictionary, NSError *error) {
        [CCView BSMBProgressHUD_hideWith:[AppDelegate sharedApplicationDelegate].window];
        if (error) {
            [CCView BSMBProgressHUD_onlyTextWithView:[AppDelegate sharedApplicationDelegate].window andText:@"网络错误，请稍后再试！"];
            completion(NO);
        }else{
            NSString *result = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"result"]];
            NSString *msg = [resultDictionary objectForKey:@"msg"];
            
            if (![result isEqualToString:@"1000"]) {
                if ([msg isEqualToString:@"您的免费观看次数已经用完,请注册充值"]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"重要提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        CCLoginViewController *lvc = [[CCLoginViewController alloc]init];
                        [viewController.navigationController pushViewController:lvc animated:YES];
                    }]];
                    [viewController presentViewController:alert animated:true completion:nil];
                    
                }else{
                    [CCView BSMBProgressHUD_onlyTextWithView:[AppDelegate sharedApplicationDelegate].window andText:msg];
                }
                completion(NO);
            }else{
                [CCView BSMBProgressHUD_onlyTextWithView:[AppDelegate sharedApplicationDelegate].window andText:msg];
                completion(YES);
            }
        }
    }];
}



//用户启动签到
+(void)MineStartSignInCompletion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    [parameterDictionary setObject:[AppDelegate sharedApplicationDelegate].userInfoModel.user_login forKey:@"mobile"];
    [parameterDictionary setObject:@"ios" forKey:@"platform"];
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiStartSignIn completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}

//手机验证码
+(void)MineVerificationCodeWithMobile:(NSString *)mobile completion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    [parameterDictionary setObject:mobile forKey:@"mobile"];
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiVerificationCode completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}

//注册
+(void)MineRegisterWithIvcode:(NSString *)ivcode andMobile:(NSString *)mobile andVcode:(NSString *)vcode andPassword:(NSString *)password completion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    if (ivcode.length == 0) {
        [parameterDictionary setObject:@"P0" forKey:@"ivcode"];
    }else{
        [parameterDictionary setObject:ivcode forKey:@"ivcode"];
    }
    
    [parameterDictionary setObject:mobile forKey:@"mobile"];
    [parameterDictionary setObject:vcode forKey:@"vcode"];
    [parameterDictionary setObject:password forKey:@"password"];
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiRegister completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}

//登陆
+(void)MineLoginWithMobile:(NSString *)mobile andPassword:(NSString *)password completion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    [parameterDictionary setObject:mobile forKey:@"mobile"];
    [parameterDictionary setObject:password forKey:@"password"];
    [parameterDictionary setObject:[CCJsonTool JsonToolUniqueAppInstanceIdentifier] forKey:@"imie"];
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiLogin completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}

//获取会员信息
+(void)MineUserInfoWithMobile:(NSString *)mobile completion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    [parameterDictionary setObject:mobile forKey:@"mobile"];
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiUserInfo completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}

//修改密码
+(void)MineChangepwdWithMobile:(NSString *)mobile andPassword:(NSString *)password andNewpassword:(NSString *)newpassword completion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    [parameterDictionary setObject:mobile forKey:@"mobile"];
    [parameterDictionary setObject:password forKey:@"password"];
    [parameterDictionary setObject:newpassword forKey:@"newpassword"];
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiChangepwd completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}





//查询积分
+(void)MineInquireIntegralWithMobile:(NSString *)mobile  completion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    [parameterDictionary setObject:mobile forKey:@"mobile"];
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiInquireIntegral completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}

//查询下载记录
+(void)MineDownloadRecordWithCode:(NSString *)code  completion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    [parameterDictionary setObject:code forKey:@"code"];
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiDownloadRecord completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}

// 查询注册记录
+(void)MineRegistrationRecordWithCode:(NSString *)code  completion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    [parameterDictionary setObject:code forKey:@"code"];
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiRegistrationRecord completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}


//积分兑换
+(void)MineRedeemPointsWithMobile:(NSString *)mobile andIntegral:(NSString *)integral completion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    [parameterDictionary setObject:mobile forKey:@"mobile"];
    [parameterDictionary setObject:integral forKey:@"integral"];
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiRedeemPoints completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}




//获取小说分类
+(void)MineFictionClassificationCompletion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiFictionClassification completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}

// 获取小说列表
+(void)MineFictionListWithPage:(NSString *)page andCid:(NSString *)cid completion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    [parameterDictionary setObject:page forKey:@"page"];
    [parameterDictionary setObject:cid forKey:@"cid"];
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiFictionList completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}

// 获取小说内容
+(void)MineFictionContentWithFictionId:(NSString *)fictionId completion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    [parameterDictionary setObject:fictionId forKey:@"id"];

    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiFictionContent completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}



//图片分类
+(void)MineImageClassificationCompletion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiImageClassification completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}

//图片列表
+(void)MineImageListWithPage:(NSString *)page andCid:(NSString *)cid completion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    [parameterDictionary setObject:page forKey:@"page"];
    [parameterDictionary setObject:cid forKey:@"cid"];
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiImageList completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}

//获取图集
+(void)MineImageContentWithFictionId:(NSString *)fictionId completion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    [parameterDictionary setObject:fictionId forKey:@"id"];
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiImageContent completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}





//直播平台
+(void)MineLivePlatformCompletion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiLivePlatform completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}

//单个平台
+(void)MinePlatformDataWithName:(NSString *)name completion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    [parameterDictionary setObject:name forKey:@"pt"];
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiPlatformData completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}

//云播平台分类
+(void)MineCloudBroadcastWithCloudBroadcastType:(CloudBroadcastType)cloudBroadcastType Completion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    
    NSString *apiPath;
    if (cloudBroadcastType == CloudBroadcastTypePronHhub) {
        apiPath = apiPronHhub;
    }else if(cloudBroadcastType == CloudBroadcastTypeXhgdy){
        apiPath = apiXhgdy;
    }else if(cloudBroadcastType == CloudBroadcastTypeEnterAVdy){
        apiPath = apiAVdy;
    }
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiPath completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}

//云播播放列表
+(void)MineCloudBroadcastListWithCloudBroadcastType:(CloudBroadcastType)cloudBroadcastType andUid:(NSString *)uid andPage:(NSInteger)page Completion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    [parameterDictionary setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    NSString *apiPath;
    if (cloudBroadcastType == CloudBroadcastTypePronHhub) {
        apiPath = apiHubList;
        [parameterDictionary setObject:uid forKey:@"uid"];
    }else if(cloudBroadcastType == CloudBroadcastTypeXhgdy){
        apiPath = apiXhgdyList;
        [parameterDictionary setObject:uid forKey:@"cid"];
    }else if(cloudBroadcastType == CloudBroadcastTypeEnterAVdy){
        apiPath = apiAVdyList;
        [parameterDictionary setObject:uid forKey:@"cid"];
    }
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiPath completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}

//PronHhub播放
+(void)MineHubPlayWithViewKey:(NSString *)viewKey Completion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    [parameterDictionary setObject:viewKey forKey:@"vk"];
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiHubPlay completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}

//小黄瓜播放
+(void)MineXHGPlayWithId:(NSString *)Id Completion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    [parameterDictionary setObject:Id forKey:@"id"];
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiXhgdyPlay completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}

+(void)MineAVPlayWithId:(NSString *)Id Completion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    [parameterDictionary setObject:Id forKey:@"id"];
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiAVdyPlay completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}


//代理联系方式查询
+(void)MineAgentContactWithAid:(NSString *)aid Completion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    [parameterDictionary setObject:aid forKey:@"aid"];
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiAgentContact completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}

//卡密兑换
+(void)MineCardExchangeWithCode:(NSString *)code andUid:(NSString *)uid  completion:(void(^) (id resultDictionary, NSError *error)) completion{
    NSMutableDictionary *parameterDictionary = [NSMutableDictionary dictionary];
    [parameterDictionary setObject:[CCJsonTool JsonHmacSha] forKey:@"key"];
    [parameterDictionary setObject:[CCJsonTool JsonGetNowTimeTimestamp] forKey:@"tm"];
    [parameterDictionary setObject:code forKey:@"code"];
    [parameterDictionary setObject:uid forKey:@"uid"];
    
    HttpService *service = [HttpService sharedService];
    [service getRequest:parameterDictionary withPath:apiCardExchange completion:^(id resultDictionary, NSError *error) {
        completion(resultDictionary,error);
    }];
}

@end
