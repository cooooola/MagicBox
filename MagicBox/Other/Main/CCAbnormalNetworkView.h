//
//  CCAbnormalNetworkView.h
//  Kingkong_ios
//
//  Created by goulela on 2017/6/2.
//  Copyright © 2017年 MC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCAbnormalNetworkViewDelegate <NSObject>

- (void)CCAbnormalNetworkView_hitReloadButtonMethod;

@end

@interface CCAbnormalNetworkView : UIView
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, weak) id<CCAbnormalNetworkViewDelegate> customDelegate;

@end
