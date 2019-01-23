//
//  CCUpdatesModel.h
//  MagicBox
//
//  Created by hello on 2018/11/22.
//  Copyright © 2018年 hello. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCUpdatesModel : NSObject
@property(nonatomic,strong)NSString *apk_url;
@property(nonatomic,strong)NSString *apk_ver;
@property(nonatomic,strong)NSString *ipa_url;
@property(nonatomic,strong)NSString *ipa_ver;
@end

NS_ASSUME_NONNULL_END
