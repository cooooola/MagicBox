//
//  CCPersonalBettingRecordHeaderView.h
//  SmallGames
//
//  Created by hello on 2018/9/23.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCBaseView.h"

@interface CCPersonalBettingRecordHeaderView : CCBaseView
@property(nonatomic,strong)void(^unsettledBetBtn)(void);
@property(nonatomic,strong)void(^bettingTodayBtn)(void);
@end
