//
//  CCLiveCollectionViewCell.m
//  MagicBox
//
//  Created by hello on 2018/11/5.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCLiveCollectionViewCell.h"

@interface CCLiveCollectionViewCell()
@property(nonatomic,strong)UIImageView *imageView;//图片
@property(nonatomic,strong)UILabel *nameLabel;//名字
@property(nonatomic,strong)UILabel *numberLabel;//数量
@property(nonatomic,strong)UIView *numberView;
@property(nonatomic,strong)UIImageView *numberImageView;

@end

@implementation CCLiveCollectionViewCell

-(void)initView{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kAdapterWith(10));
        make.width.height.equalTo(@(MCScreenWidth/6));
        make.centerX.equalTo(self);
    }];
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(kAdapterWith(5));
        make.right.equalTo(self).offset(-10);
        make.left.equalTo(self).offset(10);
    }];
    
    [self addSubview:self.numberView];
    [self.numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kAdapterWith(50)));
        make.height.equalTo(@(kAdapterWith(15)));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-kAdapterWith(10));
    }];
    
    [self.numberView addSubview:self.numberImageView];
    [self.numberImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberView).offset(kAdapterWith(7.5));
        make.centerY.equalTo(self.numberView);
    }];
    
    [self.numberView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numberView).offset(kAdapterWith(-7.5));
        make.centerY.equalTo(self.numberView);
    }];
}

-(void)setLiveModel:(CCLiveModel *)liveModel{
    _liveModel = liveModel;
    [self.imageView setImageWithURL:[NSURL URLWithString:liveModel.img] placeholder:[UIImage imageNamed:@"平台icon"]];
    self.nameLabel.text = liveModel.title;
    self.numberLabel.text = liveModel.number;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.cornerRadius = MCScreenWidth/12;
    }
    return _imageView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:kAdapterWith(14)];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.text = @"平台名称";
    }
    return _nameLabel;
}

-(UIView *)numberView{
    if (!_numberView) {
        _numberView = [[UIView alloc]init];
        _numberView.backgroundColor = [UIColor redColor];
        _numberView.layer.masksToBounds = YES;
        _numberView.layer.cornerRadius = kAdapterWith(7.5);
    }
    return _numberView;
}

-(UIImageView *)numberImageView{
    if (!_numberImageView) {
        _numberImageView = [[UIImageView alloc]init];
        _numberImageView.image = [UIImage imageNamed:@"平台小icon"];
    }
    return _numberImageView;
}

-(UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.font = [UIFont systemFontOfSize:kAdapterWith(9)];
        _numberLabel.text = @"100";
    }
    return _numberLabel;
}

@end
