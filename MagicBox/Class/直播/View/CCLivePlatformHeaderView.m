//
//  CCLivePlatformHeaderView.m
//  MagicBox
//
//  Created by hello on 2018/11/5.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCLivePlatformHeaderView.h"

@interface CCLivePlatformHeaderView()
@property(nonatomic,strong)UIImageView *imageveiw;
@property(nonatomic,strong)UIView *centerView;
@property(nonatomic,strong)UIImageView *platformImageView;
@property(nonatomic,strong)UILabel *platformNameLabel;
@property(nonatomic,strong)UILabel *platformSignatureLabel;

@property(nonatomic,strong)UIView *numberView;
@property(nonatomic,strong)UIImageView *numberIconImageView;
@property(nonatomic,strong)UILabel *numberLabel;

@end

@implementation CCLivePlatformHeaderView

-(void)initView{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.imageveiw];
    [self.imageveiw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
    }];
    
    [self addSubview:self.centerView];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self);
        make.height.equalTo(@80);
    }];
    
    [self.centerView addSubview:self.platformImageView];
    [self.platformImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView).offset(20);
        make.width.height.equalTo(@60);
        make.centerY.equalTo(self.centerView);
    }];
    
    [self.centerView addSubview:self.platformNameLabel];
    [self.platformNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.platformImageView.mas_right).offset(5);
        make.top.equalTo(self.platformImageView);
        make.height.equalTo(@30);
    }];
    
    [self.centerView addSubview:self.numberView];
    [self.numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.platformNameLabel.mas_right).offset(5);
        make.centerY.equalTo(self.platformNameLabel);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
    }];
    
    [self.numberView addSubview:self.numberIconImageView];
    [self.numberIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberView).offset(5);
        make.centerY.equalTo(self.numberView);
    }];
    
    [self.numberView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numberView).offset(-5);
        make.centerY.equalTo(self.numberView);
        make.width.equalTo(@20);
    }];
    
    
    [self.centerView addSubview:self.platformSignatureLabel];
    [self.platformSignatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.platformImageView.mas_right).offset(5);
        make.right.equalTo(self).offset(-10);
        make.bottom.equalTo(self.platformImageView);
        make.height.equalTo(@30);
    }];
}

-(void)setPlatformName:(NSString *)platformName{
    _platformName = platformName;
    self.platformNameLabel.text = platformName;
}

-(void)setPlatformImageString:(NSString *)platformImageString{
    _platformImageString = platformImageString;
    [self.platformImageView setImageWithURL:[NSURL URLWithString:platformImageString] placeholder:[UIImage imageNamed:@"平台icon"]];
}

-(void)setPlatformNumber:(NSString *)platformNumber{
    _platformImageString = platformNumber;
    self.numberLabel.text = platformNumber;
}

-(UIImageView *)imageveiw{
    if (!_imageveiw) {
        _imageveiw = [[UIImageView alloc]init];
        NSArray *imagearray = @[@"播放背景",@"播放背景_1",@"播放背景_2"];
        int r = arc4random() % [imagearray count];
        NSString *imagename = [imagearray objectAtIndex:r];
        _imageveiw.image = [UIImage imageNamed:imagename];
    }
    return _imageveiw;
}

-(UIView *)centerView{
    if (!_centerView) {
        _centerView = [[UIView alloc]init];
    }
    return _centerView;
}

-(UIImageView *)platformImageView{
    if (!_platformImageView) {
        _platformImageView = [[UIImageView alloc]init];
        _platformImageView.layer.masksToBounds = YES;
        _platformImageView.layer.cornerRadius = 30;
    }
    return _platformImageView;
}

-(UILabel *)platformNameLabel{
    if (!_platformNameLabel) {
        _platformNameLabel = [[UILabel alloc]init];
        _platformNameLabel.font = [UIFont boldSystemFontOfSize:17];
        _platformNameLabel.textColor = [UIColor blackColor];
        _platformNameLabel.text = @"平台名称";
    }
    return _platformNameLabel;
}

-(UILabel *)platformSignatureLabel{
    if (!_platformSignatureLabel) {
        _platformSignatureLabel = [[UILabel alloc]init];
        _platformSignatureLabel.font = [UIFont systemFontOfSize:12];
        _platformSignatureLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:.7];
        _platformSignatureLabel.numberOfLines = 2;
        _platformSignatureLabel.text = @"有你所要，看你想看，伴你每个寂寞的晚上！";
    }
    return _platformSignatureLabel;
}

-(UIView *)numberView{
    if (!_numberView) {
        _numberView = [[UIView alloc]init];
        _numberView.backgroundColor = [UIColor blackColor];
        _numberView.layer.masksToBounds = YES;
        _numberView.layer.cornerRadius = 3;
    }
    return _numberView;
}

-(UIImageView *)numberIconImageView{
    if (!_numberIconImageView) {
        _numberIconImageView = [[UIImageView alloc]init];
        _numberIconImageView.image = [UIImage imageNamed:@"视频"];
    }
    return _numberIconImageView;
}


-(UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.font = [UIFont systemFontOfSize:12];
        _numberLabel.text = @"100";
        _numberLabel.adjustsFontSizeToFitWidth = YES;
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}

@end
