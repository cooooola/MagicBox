//
//  CCPersonalCell.m
//  SmallGames
//
//  Created by hello on 2018/9/21.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCPersonalCell.h"
@interface CCPersonalCell()
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UILabel *titleLabel;

@end

@implementation CCPersonalCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

-(instancetype)init{
    if (self == [super init]) {
        [self initView];
    }
    return self;
}

-(void)setCellTitle:(NSString *)cellTitle{
    self.titleLabel.text = cellTitle;
    
}

-(void)initView{
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.right.bottom.equalTo(self);
    }];
    
    [self addSubview:self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
}


-(UIImageView *)rightImageView{
    if (_rightImageView == nil) {
        _rightImageView = [[UIImageView alloc]init];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rightImageView.layer.masksToBounds = YES;
        _rightImageView.image = [UIImage imageNamed:@"ARROWRIGHT"];
    }
    return _rightImageView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = MCUIColorFromRGB(0xcccccc);
    }
    return _lineView;
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = MCUIColorFromRGB(0x333333);
        _titleLabel.text = @"我的下线";
    }
    return _titleLabel;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
