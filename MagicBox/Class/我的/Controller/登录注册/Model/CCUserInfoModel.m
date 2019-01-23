//
//  CCUserInfoModel.m
//  KitchenAlwaysOnline
//
//  Created by hello on 2018/9/14.
//  Copyright © 2018年 hello. All rights reserved.
//
#define MCUserDefaults [NSUserDefaults standardUserDefaults]
#define BSUSERINFO                 @"userinfo"                       // 用户信息

#import "CCUserInfoModel.h"
#import "YYDiskCache.h"
#import "YYCache.h"

@implementation CCUserInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id" : @"id"};
}

-(BOOL)isExpired{
    return [self isMemberExpired];
}

+(void)UserInfoStorageWithObject:(NSDictionary *)array{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[self deleteNullWith:array] forKey:BSUSERINFO];
    [userDefaults synchronize];
}

+(CCUserInfoModel *)UserInfoObtain{
    NSDictionary *userInfo =  [MCUserDefaults objectForKey:BSUSERINFO];
    CCUserInfoModel *model = [CCUserInfoModel modelWithDictionary:userInfo];
    return model;
}

+(void)UserInfoRemove{
    [MCUserDefaults removeObjectForKey:BSUSERINFO];
    [MCUserDefaults synchronize];
}

#pragma 存储的数据做非空处理
+(NSDictionary *)deleteNullWith:(NSDictionary *)dic{
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *keyStr in dic.allKeys) {
        if ([[dic objectForKey:keyStr] isEqual:[NSNull null]]) {
            [mutableDic setObject:@"" forKey:keyStr];
        }else{
            [mutableDic setObject:[dic objectForKey:keyStr] forKey:keyStr];
        }
    }
    return mutableDic;
}

-(BOOL)isMemberExpired{
    if ([[self GetTimeStrWithString:_member_validity] doubleValue] < [[self NowTimeTimestamp] doubleValue]) {
        return NO;
    }
    return YES;
}

-(NSString *)GetTimeStrWithString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *tempDate = [dateFormatter dateFromString:str];
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]];
    return timeStr;
}

-(NSString *)NowTimeTimestamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}
@end


