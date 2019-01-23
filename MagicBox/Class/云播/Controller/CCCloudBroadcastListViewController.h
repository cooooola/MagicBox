//
//  CCCloudBroadcastListViewController.h
//  MagicBox
//
//  Created by hello on 2018/11/10.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCViewController.h"
#import "CCBroadcastModel.h"

@interface CCCloudBroadcastListViewController : CCViewController
@property(nonatomic,strong)CCBroadcastModel *broadcastModel;
@property(nonatomic,assign)CloudBroadcastType cloudBroadcastType;
@end
