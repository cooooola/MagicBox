//
//  CCVideoView.h
//  MagicBox
//
//  Created by cola on 2019/1/23.
//  Copyright © 2019年 hello. All rights reserved.
//

#import "CCBaseView.h"
#import "CCLivePlatformModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoView : CCBaseView
@property(nonatomic,strong)CCLivePlatformModel  *livePlatformModel;

- (instancetype)initWithViewController:(UIViewController *)viewController;

- (void)setModels:(NSArray *)models index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
