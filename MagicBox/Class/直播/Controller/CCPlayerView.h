//
//  CCPlayerView.h
//  MagicBox
//
//  Created by cola on 2019/1/23.
//  Copyright © 2019年 hello. All rights reserved.
//

#import "CCView.h"
#import "CCLivePlatformModel.h"
#import <PLPlayerKit/PLPlayerKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCPlayerView : CCBaseView
@property(nonatomic,strong)CCLivePlatformModel  *model;
@property(nonatomic,strong)PLPlayer  *player;

@end

NS_ASSUME_NONNULL_END
