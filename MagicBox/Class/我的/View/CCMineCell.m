//
//  CCMineCell.m
//  MusicHouse
//
//  Created by hello on 2018/10/10.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCMineCell.h"
@interface CCMineCell()
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIImageView *rightImageView;
@property(nonatomic,strong)UIButton *rightButton;
@property(nonatomic,strong)UILabel *titleLabel;

@end

@implementation CCMineCell
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

-(void)setIsHiddRightImg:(BOOL)isHiddRightImg{
    _isHiddRightImg = isHiddRightImg;
    if (isHiddRightImg) {
        self.rightImageView.hidden = YES;
        self.rightButton.hidden = NO;
    }else{
        self.rightImageView.hidden = NO;
        self.rightButton.hidden = YES;
    }
}


-(void)initView{
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.right.bottom.equalTo(self);
    }];
    
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(25);
        make.centerY.equalTo(self);
    }];
    
   
    
    [self addSubview:self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-20);
    }];
    
    [self addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
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
        _lineView.backgroundColor = MCUIColorFromRGB(0xeeeeee);
    }
    return _lineView;
}

-(UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = MCUIColorFromRGB(0x2f2f2f);
    }
    return _titleLabel;
}

-(UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [[UIButton alloc]init];
        _rightButton.selected = NO;
        _rightButton.hidden = YES;
        [_rightButton setImage:[UIImage imageNamed:@"按钮-灰"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"按钮-绿"] forState:UIControlStateSelected];
        [_rightButton addTarget:self action:@selector(clickRightButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

-(void)clickRightButton:(UIButton *)sender{
    sender.selected = !sender.selected;
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
