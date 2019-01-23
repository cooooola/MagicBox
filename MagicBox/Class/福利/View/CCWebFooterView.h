//
//  CCWebFooterView.h
//  MagicBox
//
//  Created by hello on 2018/11/28.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCWebFooterView : CCBaseView
@property(nonatomic,copy)void (^clickReturnBtn)(void);
@property(nonatomic,copy)void (^clickPlayBtn)(void);
@end

NS_ASSUME_NONNULL_END
