//
//  CCLivePlatformCollectionViewCell.h
//  MagicBox
//
//  Created by hello on 2018/11/7.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCCollectionViewCell.h"
#import "CCLivePlatformModel.h"
#import "CCCloudBroadcastListModel.h"

@interface CCLivePlatformCollectionViewCell : CCCollectionViewCell
@property(nonatomic,strong)UIView *numberView;
@property(nonatomic,strong)CCLivePlatformModel *livePlatformModel;
@property(nonatomic,strong)CCCloudBroadcastListModel *cloudBroadcastListModel;
@end
