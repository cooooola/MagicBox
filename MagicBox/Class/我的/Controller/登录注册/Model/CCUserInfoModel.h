//
//  CCUserInfoModel.h
//  KitchenAlwaysOnline
//
//  Created by hello on 2018/9/14.
//  Copyright © 2018年 hello. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYKit.h"

@interface CCUserInfoModel : NSObject
@property(nonatomic,strong)NSString *Id;
@property(nonatomic,strong)NSString *create_time;//注册时间
@property(nonatomic,strong)NSString *last_login_time;//最后登陆时间
@property(nonatomic,strong)NSString *member_validity;//会员过期时间
@property(nonatomic,strong)NSString *score;//积分
@property(nonatomic,strong)NSString *selfcode;//推荐码
@property(nonatomic,strong)NSString *user_login;//登陆名
@property(nonatomic,strong)NSString *user_nicename;//昵称
@property(nonatomic,strong)NSString *mastercode;

@property(nonatomic,assign)BOOL isExpired;//会员是否过期

/**
 存储用户信息

 @param array 用户信息
 */
+(void)UserInfoStorageWithObject:(NSDictionary *)array;


/**
 获取用户信息

 @return 数据返回
 */
+(CCUserInfoModel *)UserInfoObtain;

/**
 删除用户信息
 */
+(void)UserInfoRemove;

@end
