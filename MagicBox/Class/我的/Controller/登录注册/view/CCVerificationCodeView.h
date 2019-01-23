//
//  CCVerificationCodeView.h
//  SmallGames
//
//  Created by hello on 2018/9/30.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCBaseView.h"

@interface CCVerificationCodeView : CCBaseView
@property (nonatomic, retain)NSArray *CatArray;//验证码素材库
@property (nonatomic, retain)NSMutableString *CatString;//验证码字符串

//刷新验证码
-(void)refreshCode;
@end
