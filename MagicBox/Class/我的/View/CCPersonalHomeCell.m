//
//  CCPersonalHomeCell.m
//  SmallGames
//
//  Created by hello on 2018/9/20.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCPersonalHomeCell.h"
@interface CCPersonalHomeCell()
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIImageView *stepImageView;
@property(nonatomic,strong)UIImageView *rightImageView;

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *subtitleLabel;

@end

@implementation CCPersonalHomeCell

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

-(void)setCellSubtitle:(NSString *)cellSubtitle{
    self.subtitleLabel.text = cellSubtitle;
}

-(void)setCellImageName:(NSString *)cellImageName{
    self.stepImageView.image = [UIImage imageNamed:cellImageName];
}

-(void)initView{
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.right.bottom.equalTo(self);
    }];
    
    [self addSubview:self.stepImageView];
    [self addSubview:self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(40);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.subtitleLabel];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightImageView.mas_left).offset(-3);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.stepImageView];
    [self.stepImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self.mas_left).offset(20);
    }];
}

-(UIImageView *)stepImageView{
    if (_stepImageView == nil) {
        _stepImageView = [[UIImageView alloc]init];
        _stepImageView.layer.masksToBounds = YES;
    }
    return _stepImageView;
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

-(UILabel *)subtitleLabel{
    if (_subtitleLabel == nil) {
        _subtitleLabel = [[UILabel alloc]init];
        _subtitleLabel.font = [UIFont systemFontOfSize:14];
        _subtitleLabel.textColor = MCUIColorFromRGB(0x64A0D7);
        _subtitleLabel.textAlignment = NSTextAlignmentRight;
//        _subtitleLabel.text = @"10人";
    }
    return _subtitleLabel;
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
