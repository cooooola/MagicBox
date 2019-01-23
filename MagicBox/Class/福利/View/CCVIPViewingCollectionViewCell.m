//
//  CCVIPViewingCollectionViewCell.m
//  MagicBox
//
//  Created by hello on 2018/11/7.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCVIPViewingCollectionViewCell.h"

@interface CCVIPViewingCollectionViewCell()
@property(nonatomic,strong)UIImageView *imagView;
@property(nonatomic,strong)UILabel *nameLabel;
@end

@implementation CCVIPViewingCollectionViewCell

-(void)initView{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.imagView];
    [self.imagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.height.equalTo(@(MCScreenWidth/8));
        make.top.equalTo(self).offset(15);
    }];
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imagView.mas_bottom).offset(5);
        make.centerX.equalTo(self);
    }];
}

-(void)setNameString:(NSString *)nameString{
    _nameString = nameString;
    self.imagView.image = [UIImage imageNamed:nameString];
    self.nameLabel.text = nameString;
}

-(UIImageView *)imagView{
    if (!_imagView) {
        _imagView = [[UIImageView alloc]init];
        _imagView.image = [UIImage imageNamed:@"爱奇艺"];
    }
    return _imagView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.text = @"爱奇艺";
    }
    return _nameLabel;
}

@end
