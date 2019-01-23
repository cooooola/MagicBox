//
//  CCPlayOperatingView.h
//  MagicBox
//
//  Created by hello on 2018/11/9.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCBaseView.h"
#import "CCLivePlatformModel.h"

@interface CCPlayOperatingView : CCBaseView
@property(nonatomic,strong)CCLivePlatformModel *livePlatformModel;
@property(nonatomic,copy)void(^clickClosedownBtn)(void);

@end
