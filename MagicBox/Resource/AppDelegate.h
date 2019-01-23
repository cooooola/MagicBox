//
//  AppDelegate.h
//  MagicBox
//
//  Created by hello on 2018/11/1.
//  Copyright © 2018年 hello. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCUserInfoModel.h"
#import "CCFileConfigurationModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property(nonatomic,strong)CCUserInfoModel *userInfoModel;
@property(nonatomic,strong)CCFileConfigurationModel *fileConfigurationModel;
@property (strong, nonatomic) UIWindow *window;
+(AppDelegate *)sharedApplicationDelegate;

@end

