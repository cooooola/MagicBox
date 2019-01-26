//
//  CCMineManage.h
//  KitchenAlwaysOnline
//
//  Created by hello on 2018/9/14.
//  Copyright © 2018年 hello. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCMineManage : NSObject
/*******************************************配置文件****************************************/

/**
 配置文件获取

 @param completion 数据返回
 */
+(void)MineConfigurationFileCompletion:(void(^) (id resultDictionary, NSError *error)) completion;


/**
 会员检测

 @param completion 数据返回
 */
+(void)MineMemberInspectionWithViewController:(UIViewController *)viewController Completion:(void(^) (BOOL MemberStatus)) completion;



/**
 未注册登录串号检测

 @param completion 数据返回
 */
+(void)MinePreviewWithViewController:(UIViewController *)viewController Completion:(void(^) (BOOL PreviewStatus)) completion;


/*******************************************用户管理****************************************/

/**
 用户启动签到

 @param completion 数据返回
 */
+(void)MineStartSignInCompletion:(void(^) (id resultDictionary, NSError *error)) completion;


/**
 手机验证码

 @param mobile 手机号
 @param completion 数据返回
 */
+(void)MineVerificationCodeWithMobile:(NSString *)mobile completion:(void(^) (id resultDictionary, NSError *error)) completion;


/**
  用户注册

 @param ivcode 邀请码
 @param mobile 用户手机号
 @param vcode 短信验证码
 @param password 用户密码
 @param completion 数据返回
 */
+(void)MineRegisterWithIvcode:(NSString *)ivcode andMobile:(NSString *)mobile andVcode:(NSString *)vcode andPassword:(NSString *)password completion:(void(^) (id resultDictionary, NSError *error)) completion;


/**
 用户登录

 @param mobile 手机号码
 @param password 密码
 @param completion 数据返回
 */
+(void)MineLoginWithMobile:(NSString *)mobile andPassword:(NSString *)password completion:(void(^) (id resultDictionary, NSError *error)) completion;


/**
 获取会员信息

 @param mobile 手机号码
 @param completion 数据返回
 */
+(void)MineUserInfoWithMobile:(NSString *)mobile completion:(void(^) (id resultDictionary, NSError *error)) completion;


/**
 修改密码

 @param mobile 手机号码
 @param password 密码
 @param newpassword 新密码
 @param completion 数据返回
 */
+(void)MineChangepwdWithMobile:(NSString *)mobile andPassword:(NSString *)password andNewpassword:(NSString *)newpassword completion:(void(^) (id resultDictionary, NSError *error)) completion;


/*******************************************积分***************************************/


/**
 查询积分

 @param mobile 手机号
 @param completion 数据返回
 */
+(void)MineInquireIntegralWithMobile:(NSString *)mobile  completion:(void(^) (id resultDictionary, NSError *error)) completion;


/**
 查询下载记录

 @param code 自己的推荐码
 @param completion 数据返回
 */
+(void)MineDownloadRecordWithCode:(NSString *)code  completion:(void(^) (id resultDictionary, NSError *error)) completion;


/**
 查询注册记录

 @param code 自己的推荐码
 @param completion 数据返回
 */
+(void)MineRegistrationRecordWithCode:(NSString *)code  completion:(void(^) (id resultDictionary, NSError *error)) completion;


/**
 兑换积分

 @param mobile 手机号码
 @param integral 兑换的积分
 @param completion 数据返回
 */
+(void)MineRedeemPointsWithMobile:(NSString *)mobile andIntegral:(NSString *)integral completion:(void(^) (id resultDictionary, NSError *error)) completion;



/*******************************************小说***************************************/

/**
 小说分类

 @param completion 数据返回
 */
+(void)MineFictionClassificationCompletion:(void(^) (id resultDictionary, NSError *error)) completion;


/**
 获取小说列表

 @param page 页码
 @param cid 分类id
 @param completion 数据返回
 */
+(void)MineFictionListWithPage:(NSString *)page andCid:(NSString *)cid completion:(void(^) (id resultDictionary, NSError *error)) completion;


/**
 获取小说内容

 @param fictionId 小说id
 @param completion 数据返回
 */
+(void)MineFictionContentWithFictionId:(NSString *)fictionId completion:(void(^) (id resultDictionary, NSError *error)) completion;



/*******************************************图片*****************************************/

/**
 图片分类
 
 @param completion 数据返回
 */
+(void)MineImageClassificationCompletion:(void(^) (id resultDictionary, NSError *error)) completion;


/**
 获取图片列表
 
 @param page 页码
 @param cid 分类id
 @param completion 数据返回
 */
+(void)MineImageListWithPage:(NSString *)page andCid:(NSString *)cid completion:(void(^) (id resultDictionary, NSError *error)) completion;


/**
 获取图片内容
 
 @param fictionId 图片id
 @param completion 数据返回
 */
+(void)MineImageContentWithFictionId:(NSString *)fictionId completion:(void(^) (id resultDictionary, NSError *error)) completion;


/*******************************************直播*************************************/


/**
 直播平台

 @param completion 数据返回
 */
+(void)MineLivePlatformCompletion:(void(^) (id resultDictionary, NSError *error)) completion;


/**
 单个平台

 @param name 平台名称
 @param completion 数据返回
 */
+(void)MinePlatformDataWithName:(NSString *)name completion:(void(^) (id resultDictionary, NSError *error)) completion;


/**
 云播平台分类
 
 @param cloudBroadcastType 平台类型
 @param completion 数据返回
 */
+(void)MineCloudBroadcastWithCloudBroadcastType:(CloudBroadcastType)cloudBroadcastType Completion:(void(^) (id resultDictionary, NSError *error)) completion;


/**
 播放列表

 @param cloudBroadcastType 平台类型
 @param uid 分类id
 @param page 分页
 @param completion 数据返回
 */
+(void)MineCloudBroadcastListWithCloudBroadcastType:(CloudBroadcastType)cloudBroadcastType andUid:(NSString *)uid andPage:(NSInteger)page Completion:(void(^) (id resultDictionary, NSError *error)) completion;


//PronHhub播放
+(void)MineHubPlayWithViewKey:(NSString *)viewKey Completion:(void(^) (id resultDictionary, NSError *error)) completion;

//小黄瓜播放
+(void)MineXHGPlayWithId:(NSString *)Id Completion:(void(^) (id resultDictionary, NSError *error)) completion;

//av影院
+(void)MineAVPlayWithId:(NSString *)Id Completion:(void(^) (id resultDictionary, NSError *error)) completion;

/*******************************************代理***************************************************/

/**
 代理联系方式

 @param aid 代理的推荐码
 @param completion 数据返回
 */
+(void)MineAgentContactWithAid:(NSString *)aid Completion:(void(^) (id resultDictionary, NSError *error)) completion;


/**
  卡密兑换

 @param code code
 @param uid uid
 @param completion 数据返回
 */
+(void)MineCardExchangeWithCode:(NSString *)code andUid:(NSString *)uid  completion:(void(^) (id resultDictionary, NSError *error)) completion;


@end
