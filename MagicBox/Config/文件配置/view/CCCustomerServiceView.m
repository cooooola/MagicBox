//
//  CCCustomerServiceView.m
//  SmallGames
//
//  Created by hello on 2018/9/20.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCCustomerServiceView.h"
@interface CCCustomerServiceView()
@property(nonatomic,strong)UIView *showView;
@property(nonatomic,strong)UIButton *confirmButton;
@property(nonatomic,strong)UILabel *showMessageLabel;
@property(nonatomic,strong)UIView *viewLine;
@end

@implementation CCCustomerServiceView

-(void)initView{
    [super initView];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.4];
    
    [self addSubview:self.showView];
    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.center.equalTo(self);
        make.height.equalTo(@230);
    }];
    
    [self.showView addSubview:self.showMessageLabel];
    [self.showMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.showView).offset(10);
        make.right.equalTo(self.showView).offset(-10);
        make.bottom.equalTo(self.showView).offset(-60);
    }];
    
    [self.showView addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.right.left.bottom.equalTo(self.showView);
    }];
    
    [self.showView addSubview:self.viewLine];
    [self.viewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.showView);
        make.bottom.equalTo(self.confirmButton.mas_top);
        make.height.equalTo(@1);
    }];
}

-(UIView *)showView{
    if (_showView == nil) {
        _showView = [[UIView alloc]init];
        _showView.backgroundColor = MCUIColorFromRGB(0x424357);
        _showView.layer.masksToBounds = YES;
        _showView.layer.cornerRadius = 5;
    }
    return _showView;
}

-(UILabel *)showMessageLabel{
    if (_showMessageLabel == nil) {
        _showMessageLabel = [[UILabel alloc]init];
        _showMessageLabel.font = [UIFont systemFontOfSize:17];
        _showMessageLabel.textColor = MCUIColorFromRGB(0x80829c);
//        _showMessageLabel.textAlignment = NSTextAlignmentCenter;
        _showMessageLabel.numberOfLines = 0;
    }
    return _showMessageLabel;
}

- (UIButton *)confirmButton {
    if (_confirmButton == nil) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setBackgroundColor:MCUIColorMain];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(clickConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    } return _confirmButton;
}

-(UIView *)viewLine{
    if (!_viewLine) {
        _viewLine = [[UIView alloc]init];
        _viewLine.backgroundColor = MCUIColorFromRGB(0xEEEFF0);
    }
    return _viewLine;
}


-(void)setViewMessageString:(NSString *)viewMessageString{
    self.showMessageLabel.text = viewMessageString;
}

-(void)clickConfirmButton{
    [self removeFromSuperview];
}

@end
