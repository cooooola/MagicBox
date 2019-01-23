//
//  CCMinePointsCenterViewController.m
//  MagicBox
//
//  Created by hello on 2018/11/15.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCMinePointsCenterViewController.h"
#import "CCPointDetailsViewController.h"
#import "CCPointAcquisitionViewController.h"

@interface CCMinePointsCenterViewController()
@property(nonatomic,assign)NSInteger timeString;
@property(nonatomic,strong)UILabel *currentPointsTitleLabel;
@property(nonatomic,strong)UILabel *currentPointsLabel;

@property(nonatomic,strong)UIButton *earnPointsButton;

@property(nonatomic,strong)UILabel *exchangeTitleLabel;
@property(nonatomic,strong)UIView *timeView;
@property(nonatomic,strong)UIView *timeviewline;
@property(nonatomic,strong)UIView *linetimeview;

@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIButton *addButton;
@property(nonatomic,strong)UIButton *reduceButton;

@property(nonatomic,strong)UIButton *redemptionConfirmationButton;


@end

@implementation CCMinePointsCenterViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
}

-(void)initView{
    self.title = @"积分中心";
    self.navigationItem.leftBarButtonItem = self.customLeftItem;
    self.view.backgroundColor = MCUIColorFromRGB(0xe9e9e9);
    
    [CCView BSBarButtonItem_text_who:self.navigationItem size:CGSizeMake(60, 44) target:self selected:@selector(clickPointsDetails) textColor:[UIColor blackColor] font:13 andText:@"积分详情" isLeft:1];
    
    [self.view addSubview:self.currentPointsTitleLabel];
    [self.currentPointsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@70);
        make.left.equalTo(self.view).offset(40);
    }];
    
    [self.view addSubview:self.currentPointsLabel];
    [self.currentPointsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.currentPointsTitleLabel);
        make.left.equalTo(self.currentPointsTitleLabel.mas_right).offset(20);
    }];
    
    [self.view addSubview:self.earnPointsButton];
    [self.earnPointsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.currentPointsLabel.mas_bottom).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(20);
        make.height.equalTo(@50);
    }];
    
    
    [self.view addSubview:self.exchangeTitleLabel];
    [self.exchangeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.earnPointsButton.mas_bottom).offset(40);
        make.left.equalTo(self.view).offset(40);
    }];
    
    [self.view addSubview:self.timeView];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(50);
        make.right.equalTo(self.view).offset(-50);
        make.top.equalTo(self.exchangeTitleLabel.mas_bottom).offset(15);
        make.height.equalTo(@50);
    }];
    
    float lineW = (MCScreenWidth - 102)/3;
    
    [self.timeView addSubview:self.timeviewline];
    [self.timeviewline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeView).offset(lineW);
        make.width.equalTo(@1);
        make.top.bottom.equalTo(self.timeView);
    }];
    
    [self.timeView addSubview:self.linetimeview];
    [self.linetimeview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeView).offset(-(lineW));
        make.width.equalTo(@1);
        make.top.bottom.equalTo(self.timeView);
    }];
    
    
    [self.timeView addSubview:self.reduceButton];
    [self.reduceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.timeView);
        make.right.equalTo(self.timeviewline.mas_left);
    }];
    
    [self.timeView addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.timeView);
        make.left.equalTo(self.linetimeview.mas_right);
    }];
    
    [self.timeView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.timeView);
    }];
    
    
    
    [self.view addSubview:self.redemptionConfirmationButton];
    [self.redemptionConfirmationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeView.mas_bottom).offset(40);
        make.right.equalTo(self.view).offset(-20);
        make.left.equalTo(self.view).offset(20);
        make.height.equalTo(@50);
    }];
    
    self.timeString = 0;
}

-(UILabel *)currentPointsTitleLabel{
    if (!_currentPointsTitleLabel) {
        _currentPointsTitleLabel = [[UILabel alloc]init];
        _currentPointsTitleLabel.textColor = [UIColor blackColor];
        _currentPointsTitleLabel.text = @"当前积分:";
        _currentPointsTitleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _currentPointsTitleLabel;
}



-(UILabel *)currentPointsLabel{
    if (!_currentPointsLabel) {
        _currentPointsLabel = [[UILabel alloc]init];
        _currentPointsLabel.textColor = MCUIColorMain;
        _currentPointsLabel.text = [NSString stringWithFormat:@"%@ 分",[AppDelegate sharedApplicationDelegate].userInfoModel.score];
        _currentPointsLabel.font = [UIFont systemFontOfSize:30];
    }
    return _currentPointsLabel;
}

-(UIButton *)earnPointsButton{
    if (!_earnPointsButton) {
        _earnPointsButton = [[UIButton alloc]init];
        _earnPointsButton.backgroundColor = MCUIColorMain;
        _earnPointsButton.layer.masksToBounds = YES;
        _earnPointsButton.layer.cornerRadius = 25;
        _earnPointsButton.titleLabel.font = [UIFont systemFontOfSize:19];
        [_earnPointsButton setTitle:@"获取积分" forState:UIControlStateNormal];
        [_earnPointsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_earnPointsButton addTarget:self action:@selector(clickEarnPointsButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _earnPointsButton;
}


-(UILabel *)exchangeTitleLabel{
    if (!_exchangeTitleLabel) {
        _exchangeTitleLabel = [[UILabel alloc]init];
        _exchangeTitleLabel.textColor = [UIColor orangeColor];
        _exchangeTitleLabel.text = @"1个积分可以获取1分钟观看时间";
        _exchangeTitleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _exchangeTitleLabel;
}

-(UIView *)timeView{
    if (!_timeView) {
        _timeView = [[UIView alloc]init];
        _timeView.layer.masksToBounds = YES;
        _timeView.layer.borderWidth = 1;
        _timeView.layer.borderColor = [[UIColor colorWithRed:19/255.0 green:150/255.0 blue:239/255.0 alpha:1] CGColor];
        _timeView.layer.cornerRadius = 4;
    }
    return _timeView;
}

-(UIView *)timeviewline{
    if (!_timeviewline) {
        _timeviewline = [[UIView alloc]init];
        _timeviewline.backgroundColor = [UIColor colorWithRed:19/255.0 green:150/255.0 blue:239/255.0 alpha:1];
    }
    return _timeviewline;
}

-(UIView *)linetimeview{
    if (!_linetimeview) {
        _linetimeview = [[UIView alloc]init];
        _linetimeview.backgroundColor = [UIColor colorWithRed:19/255.0 green:150/255.0 blue:239/255.0 alpha:1];
    }
    return _linetimeview;
}

-(UIButton *)addButton{
    if (!_addButton) {
        _addButton = [[UIButton alloc]init];
        [_addButton setTitle:@"+" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor colorWithRed:19/255.0 green:150/255.0 blue:239/255.0 alpha:1] forState:UIControlStateNormal];
        [_addButton.titleLabel setFont:[UIFont systemFontOfSize:25]];
        [_addButton addTarget:self action:@selector(clickAddButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

-(UIButton *)reduceButton{
    if (!_reduceButton) {
        _reduceButton = [[UIButton alloc]init];
        [_reduceButton setTitle:@"-" forState:UIControlStateNormal];
        [_reduceButton setTitleColor:[UIColor colorWithRed:19/255.0 green:150/255.0 blue:239/255.0 alpha:1] forState:UIControlStateNormal];
        [_reduceButton.titleLabel setFont:[UIFont systemFontOfSize:25]];
        [_reduceButton addTarget:self action:@selector(clickReduceButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduceButton;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.font = [UIFont systemFontOfSize:25];
    }
    return _timeLabel;
}



-(UIButton *)redemptionConfirmationButton{
    if (!_redemptionConfirmationButton) {
        _redemptionConfirmationButton = [[UIButton alloc]init];
        _redemptionConfirmationButton.backgroundColor = MCUIColorMain;
        _redemptionConfirmationButton.layer.masksToBounds = YES;
        _redemptionConfirmationButton.layer.cornerRadius = 25;
        _redemptionConfirmationButton.titleLabel.font = [UIFont systemFontOfSize:19];
        [_redemptionConfirmationButton setTitle:@"确认兑换" forState:UIControlStateNormal];
        [_redemptionConfirmationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_redemptionConfirmationButton addTarget:self action:@selector(clickRedemptionConfirmationButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _redemptionConfirmationButton;
}



#pragma 积分详情
-(void)clickPointsDetails{
    CCPointDetailsViewController *pdvc = [[CCPointDetailsViewController alloc]init];
    [self.navigationController pushViewController:pdvc animated:YES];
}

#pragma 获取积分
-(void)clickEarnPointsButton{
    CCPointAcquisitionViewController *pavc = [[CCPointAcquisitionViewController alloc]init];
    [self.navigationController pushViewController:pavc animated:YES];
}

#pragma 加分
-(void)clickAddButton{
    if ([[AppDelegate sharedApplicationDelegate].userInfoModel.score integerValue] == 0) {
        [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"当前没有可用的积分！"];
        return;
    }
    if (_timeString == [[AppDelegate sharedApplicationDelegate].userInfoModel.score integerValue]) {
        [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"当前已为最大可用积分"];
        return;
    }
    
    self.timeString = _timeString + 1;
}

#pragma 减分
-(void)clickReduceButton{
    if (_timeString == 0) {
        [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"当前时间已为0"];
        return;
    }
    self.timeString = _timeString - 1;
}

#pragma 时间兑换
-(void)clickRedemptionConfirmationButton{
    if (_timeString == 0) {
        [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"请设置兑换的时间！"];
        return;
    }
    
    [CCView BSMBProgressHUD_bufferAndTextWithView:self.view andText:@"正在兑换中，请稍候..."];
    [CCMineManage MineRedeemPointsWithMobile:[AppDelegate sharedApplicationDelegate].userInfoModel.user_login andIntegral:[NSString stringWithFormat:@"%ld",(long)_timeString] completion:^(id resultDictionary, NSError *error) {
        [CCView BSMBProgressHUD_hideWith:self.view];
        if (error) {
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"网络错误，请稍后再试！"];
        }else{
            NSString *result = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"result"]];
            NSString *msg = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"msg"]];
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:msg];
            if ([result isEqualToString:@"1000"]) {
                self.currentPointsLabel.text = [NSString stringWithFormat:@"%ld 分",[[AppDelegate sharedApplicationDelegate].userInfoModel.score integerValue] - self->_timeString];
                self.timeString = 0;
                [self getUserInformation];
            }
        }
    }];
}

-(void)getUserInformation{
    [CCMineManage MineUserInfoWithMobile:[AppDelegate sharedApplicationDelegate].userInfoModel.user_login completion:^(id resultDictionary, NSError *error) {
        if (!error){
            NSString *result = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"result"]];
            if ([result isEqualToString:@"1000"]) {
                NSDictionary *userInfoDic = [resultDictionary objectForKey:@"data"];
                [CCUserInfoModel UserInfoStorageWithObject:userInfoDic];
                [AppDelegate sharedApplicationDelegate].userInfoModel = [CCUserInfoModel modelWithDictionary:userInfoDic];
            }
        }
    }];
}


-(void)setTimeString:(NSInteger)timeString{
    _timeString = timeString;
    _timeLabel.text = [NSString stringWithFormat:@"%ld",(long)timeString];
}




@end
