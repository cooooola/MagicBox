//
//  CCMineHeaderView.h
//  MagicBox
//
//  Created by hello on 2018/11/5.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCBaseView.h"
#import "CCUserInfoModel.h"
@interface CCMineHeaderView : CCBaseView
@property(nonatomic,strong)CCUserInfoModel *userInfoModel;
@property(nonatomic,strong)void(^loginBtn)(void);
@end
