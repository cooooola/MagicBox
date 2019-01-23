//
//  CCFileConfigurationModel.m
//  MagicBox
//
//  Created by hello on 2018/11/22.
//  Copyright © 2018年 hello. All rights reserved.
//
#define BSUSERINFO                 @"fileconfiguration"                       // 用户信息

#import "CCFileConfigurationModel.h"
#import "YYCache.h"

@implementation CCFileConfigurationModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"liveadv" : [CCImgModel class],
             @"roomadv" : [CCImgModel class],
             @"silderadv" : [CCSilderadvModel class] };
}


+(void)FileConfigurationWithObject:(NSDictionary *)array{
    YYCache *cacheCF = [[YYCache alloc]initWithName:BSUSERINFO];
    [cacheCF setObject:array forKey:@"CF"];
    [cacheCF diskCache];
}

+(CCFileConfigurationModel *)FileConfigurationObtain{
    YYCache *cacheCF = [[YYCache alloc]initWithName:BSUSERINFO];
    id CFInfo = [cacheCF objectForKey:@"CF"];
    CCFileConfigurationModel *model = [CCFileConfigurationModel modelWithDictionary:CFInfo];
    return model;
}
@end
