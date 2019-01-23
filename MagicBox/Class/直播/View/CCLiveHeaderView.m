//
//  CCLiveHeaderView.m
//  MagicBox
//
//  Created by hello on 2018/11/5.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCLiveHeaderView.h"

@interface CCLiveHeaderView()
@property(nonatomic,strong)UIView *imageView;
@property(nonatomic,strong)UIView *lineview;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *numberLabel;
@end

@implementation CCLiveHeaderView

-(void)initView{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(12.5);
        make.bottom.equalTo(self).offset(-12.5);
        make.width.equalTo(@2);
    }];
    
    [self addSubview:self.lineview];
    [self.lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(4);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self);
    }];
}

-(void)setLiveNumber:(NSString *)liveNumber{
    _liveNumber = liveNumber;
    self.numberLabel.text = [NSString stringWithFormat:@"共 %@ 个",liveNumber];
}

-(UIView *)imageView{
    if (!_imageView) {
        _imageView = [[UIView alloc]init];
        _imageView.backgroundColor = [UIColor blackColor];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = 1;
    }
    return _imageView;
}

-(UIView *)lineview{
    if (!_lineview) {
        _lineview = [[UIView alloc]init];
        _lineview.backgroundColor = MCUIColorFromRGB(0xe9e9e9);
    }
    return _lineview;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.text = @"热门直播平台";
    }
    return _nameLabel;
}

-(UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.textColor = MCUIColorFromRGB(0x8c8c8c);
        _numberLabel.font = [UIFont systemFontOfSize:12];
        _numberLabel.text = @"共 0 个";
    }
    return _numberLabel;
}

@end
