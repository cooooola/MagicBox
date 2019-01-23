//
//  CCFileConfigurationModel.h
//  MagicBox
//
//  Created by hello on 2018/11/22.
//  Copyright © 2018年 hello. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCCardsModel.h"
#import "CCImgModel.h"
#import "CCShareModel.h"
#import "CCSilderadvModel.h"
#import "CCSitesModel.h"
#import "CCUpdatesModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CCFileConfigurationModel : NSObject
@property(nonatomic,strong)CCCardsModel *cards;//卡密地址
@property(nonatomic,strong)NSArray *liveadv;//直播广告
@property(nonatomic,strong)NSArray *roomadv;//云播播放器广告
@property(nonatomic,strong)CCShareModel *share;//分享用数据
@property(nonatomic,strong)NSArray *silderadv;//轮播广告数据
@property(nonatomic,strong)CCSitesModel *sites;//站点信息
@property(nonatomic,strong)CCUpdatesModel *updates;//App更新数据


+(void)FileConfigurationWithObject:(NSDictionary *)array;

+(CCFileConfigurationModel *)FileConfigurationObtain;
@end



NS_ASSUME_NONNULL_END
