//
//  CCPointsTableViewCell.h
//  MagicBox
//
//  Created by hello on 2018/11/15.
//  Copyright © 2018年 hello. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCPointsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface CCPointsTableViewCell : UITableViewCell
@property(nonatomic,strong)CCPointsModel *pointsModel;
@end

NS_ASSUME_NONNULL_END
