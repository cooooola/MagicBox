//
//  CCPointsTableViewCell.m
//  MagicBox
//
//  Created by hello on 2018/11/15.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCPointsTableViewCell.h"

@interface CCPointsTableViewCell()
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *nameLabel;
@end

@implementation CCPointsTableViewCell
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

-(void)setPointsModel:(CCPointsModel *)pointsModel{
    _pointsModel = pointsModel;
    self.timeLabel.text = pointsModel.tm;
    self.nameLabel.text = pointsModel.uid;
}

-(void)initView{
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.left.right.bottom.equalTo(self);
    }];
    
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self);
    }];
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self);
    }];
    
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = MCUIColorFromRGB(0xeeeeee);
    }
    return _lineView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = MCUIColorFromRGB(0x2f2f2f);
        _nameLabel.text = @"我是新注册的用户名";
    }
    return _nameLabel;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = MCUIColorFromRGB(0x2f2f2f);
        _timeLabel.text = @"2018-11-16 22:00:00";
    }
    return _timeLabel;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
