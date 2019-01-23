//
//  CCUserInfoView.m
//  Kingkong_ios
//
//  Created by 222 on 2018/1/20.
//  Copyright © 2018年 MC. All rights reserved.
//

#import "CCUserInfoView.h"
#import "Masonry.h"

@interface CCUserInfoView()

@property (nonatomic, strong)UIView *bottomLine;

@end

@implementation CCUserInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI {
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.bottom.equalTo(self).offset(-1);
    }];
    
    [self addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(1);
    }];
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
        [_textField setValue: [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1/1.0] forKeyPath:@"_placeholderLabel.textColor"];
        [_textField setValue:[UIFont boldSystemFontOfSize:18] forKeyPath:@"_placeholderLabel.font"];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.textColor = [UIColor whiteColor];
    }
    return _textField;
}

- (UIView *)bottomLine {
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1];
    }
    return _bottomLine;
}
@end
