//
//  CCAbnormalNetworkView.m
//  Kingkong_ios
//
//  Created by goulela on 2017/6/2.
//  Copyright © 2017年 MC. All rights reserved.
//

#import "CCAbnormalNetworkView.h"

@interface CCAbnormalNetworkView ()


@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) UIButton * reloadButton;

@end

@implementation CCAbnormalNetworkView


- (void)drawRect:(CGRect)rect {
    
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self).with.offset(MCScreenHeight / 6);
        make.size.mas_equalTo(CGSizeMake(175, 160));
    }];
    
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.imageView.mas_bottom).with.offset(3);
        make.height.mas_equalTo(18);
    }];
    
    [self addSubview:self.reloadButton];
    [self.reloadButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.label.mas_bottom).with.offset(45);
        make.size.mas_equalTo(CGSizeMake(160, 44));
    }];
}

- (void)reloadButtonClieked {
    
    [self removeFromSuperview];
    
    if (self.customDelegate && [self.customDelegate respondsToSelector:@selector(CCAbnormalNetworkView_hitReloadButtonMethod)]) {
        [self.customDelegate CCAbnormalNetworkView_hitReloadButtonMethod];
    }
}


#pragma mark - setter & getter
- (UIImageView *)imageView {
    if (_imageView == nil) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.image = [UIImage imageNamed:@"Reuse_404"];
    } return _imageView;
}

- (UILabel *)label {
    if (_label == nil) {
        self.label = [[UILabel alloc] init];
        self.label.textColor = MCUIColorMiddleGray;
        self.label.font = MCFont(18.0f);
        self.label.text = @"暂无数据";
    } return _label;
}

- (UIButton *)reloadButton {
    if (_reloadButton == nil) {
        self.reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.reloadButton.layer.masksToBounds = YES;
        self.reloadButton.layer.cornerRadius = 5;
        self.reloadButton.layer.borderColor = MCUIColorMain.CGColor;
        self.reloadButton.layer.borderWidth = 1;
        self.reloadButton.titleLabel.font = MCFont(16);
        [self.reloadButton setTitle: @"刷新页面"forState:UIControlStateNormal];
        [self.reloadButton setTitleColor:MCUIColorMain forState:UIControlStateNormal];
        [self.reloadButton addTarget:self action:@selector(reloadButtonClieked) forControlEvents:UIControlEventTouchUpInside];
    } return _reloadButton;
}

@end
