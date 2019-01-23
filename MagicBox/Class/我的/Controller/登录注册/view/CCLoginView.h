//
//  CCLoginView.h
//  SmallGames
//
//  Created by hello on 2018/9/19.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCBaseView.h"
#import "CCUserInfoView.h"
#import "CCVerificationCodeView.h"
@interface CCLoginView : CCBaseView
@property(nonatomic,strong) CCUserInfoView *userNameView;//用户名
@property(nonatomic,strong) CCUserInfoView *codeView;//验证码
@property(nonatomic,strong) CCUserInfoView *passwordView;//密码
@property(nonatomic,strong) CCUserInfoView *confirmView;//确认密码
@property(nonatomic,strong) CCUserInfoView *referrerView;//推荐人
@property(nonatomic,strong) CCVerificationCodeView *verificationCodeView;
@end
