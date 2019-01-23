//
//  CCEmptyDataView.m
//  SchoolMakeUp
//
//  Created by goulela on 16/10/27.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "CCEmptyDataView.h"
@implementation CCEmptyDataView

-(void)initView{
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-30);
    }];

    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.imageView.mas_bottom).with.offset(20);
    }];
}

#pragma mark - setter & getter 
- (UIImageView *)imageView {
    if (_imageView == nil) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.image = [UIImage imageNamed:@"zaiwushuju"];
    } return _imageView;
}

- (UILabel *)label {
    if (_label == nil) {
        self.label = [[UILabel alloc] init];
        self.label.textColor = MCUIColorFromRGB(0xBFBFBF);
        self.label.font = MCFont(17.0f);
        self.label.text = @"暂无此类数据";
    } return _label;
}

@end
