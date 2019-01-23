//
//  CCLivePlatformCollectionViewCell.m
//  MagicBox
//
//  Created by hello on 2018/11/7.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCLivePlatformCollectionViewCell.h"

@interface CCLivePlatformCollectionViewCell()
@property(nonatomic,strong)UIImageView *imageView;//图片
@property(nonatomic,strong)UIView *nameView;
@property(nonatomic,strong)UILabel *nameLabel;//名字
@property(nonatomic,strong)UILabel *numberLabel;//数量
@property(nonatomic,strong)UIImageView *numberImageView;
@end

@implementation CCLivePlatformCollectionViewCell

-(void)initView{
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.nameView];
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@20);
    }];
    [self.nameView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.nameView);
        make.left.equalTo(self.nameView).offset(5);
        make.right.equalTo(self.nameView).offset(-5);
    }];
    
    [self addSubview:self.numberView];
    [self.numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kAdapterWith(50)));
        make.height.equalTo(@(kAdapterWith(15)));
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
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

-(void)setLivePlatformModel:(CCLivePlatformModel *)livePlatformModel{
    _livePlatformModel = livePlatformModel;
    [self.imageView setImageWithURL:[NSURL URLWithString:livePlatformModel.img] placeholder:[UIImage imageNamed:@"平台icon"]];
    self.nameLabel.text = livePlatformModel.title;
}

-(void)setCloudBroadcastListModel:(CCCloudBroadcastListModel *)cloudBroadcastListModel{
    _cloudBroadcastListModel = cloudBroadcastListModel;
    
    [self.imageView setImageWithURL:[NSURL URLWithString:cloudBroadcastListModel.coverimage] placeholder:[UIImage imageNamed:@"平台icon"]];
    self.nameLabel.text = cloudBroadcastListModel.title;
    self.numberImageView.image = [UIImage imageNamed:@"影片时长"];
    self.numberLabel.text = cloudBroadcastListModel.ctime;
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"播放背景"];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

-(UIView *)nameView{
    if (!_nameView) {
        _nameView = [[UIView alloc]init];
        _nameView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _nameView.alpha = 0.5;
    }
    return _nameView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:kAdapterWith(12)];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.text = @"平台名称";
    }
    return _nameLabel;
}

-(UIView *)numberView{
    if (!_numberView) {
        _numberView = [[UIView alloc]init];
        _numberView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _numberView.layer.masksToBounds = YES;
        _numberView.layer.cornerRadius = kAdapterWith(7.5);
    }
    return _numberView;
}

-(UIImageView *)numberImageView{
    if (!_numberImageView) {
        _numberImageView = [[UIImageView alloc]init];
        _numberImageView.image = [UIImage imageNamed:@"用户数量"];
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
