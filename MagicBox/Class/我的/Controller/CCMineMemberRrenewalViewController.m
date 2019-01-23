//
//  CCMineMemberRrenewalViewController.m
//  MagicBox
//
//  Created by hello on 2018/11/7.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCMineMemberRrenewalViewController.h"
#import "CCWebViewController.h"


@interface CCMineMemberRrenewalViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *cardTextField;
@property(nonatomic,strong)UIButton *renewalFeeButton;

@property(nonatomic,strong)UIView *buttonView;

@property(nonatomic,strong)UIButton *monthlyButton;
@property(nonatomic,strong)UIButton *seasonButton;
@property(nonatomic,strong)UIButton *yearButton;
@property(nonatomic,strong)UIButton *permanentButton;

@property(nonatomic,strong)UIView *messageView;
@property(nonatomic,strong)UILabel *messageQQLabel;
@property(nonatomic,strong)UILabel *messagewechatLabel;
@property(nonatomic,strong)UILabel *messageLabel;

@property(nonatomic,strong)UILabel *kamiTitleLabel;
@property(nonatomic,strong)UILabel *zaixianTitleLabel;
@end

@implementation CCMineMemberRrenewalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
}

-(void)initView{
    self.title = @"会员续费";
    self.navigationItem.leftBarButtonItem = self.customLeftItem;
    self.view.backgroundColor = MCUIColorFromRGB(0xe9e9e9);
    
    [self.view addSubview:self.kamiTitleLabel];
    [self.kamiTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15);
        make.left.equalTo(self.view).offset(15);
    }];
    
    [self.view addSubview:self.cardTextField];
    [self.cardTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.kamiTitleLabel.mas_bottom).offset(5);
        make.height.equalTo(@50);
    }];
    
    [self.view addSubview:self.renewalFeeButton];
    [self.renewalFeeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardTextField.mas_bottom).offset(25);
        make.left.equalTo(self.view).offset(25);
        make.right.equalTo(self.view).offset(-25);
        make.height.equalTo(@50);
    }];
    
    [self.view addSubview:self.buttonView];
    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.renewalFeeButton.mas_bottom).offset(15);
    }];
    
    [self.buttonView addSubview:self.zaixianTitleLabel];
    [self.zaixianTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buttonView).offset(15);
        make.left.equalTo(self.buttonView).offset(15);
    }];
    
    
    [self.buttonView addSubview:self.monthlyButton];
    float buttonW = (MCScreenWidth - 65)/2;
    float buttonH = buttonW *5/6;
    [self.monthlyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(25);
        make.top.equalTo(self.zaixianTitleLabel.mas_bottom).offset(10);
        make.width.equalTo(@(buttonW));
        make.height.equalTo(@(buttonH));
    }];
    
    [self.buttonView addSubview:self.seasonButton];
    [self.seasonButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-25);
        make.top.equalTo(self.zaixianTitleLabel.mas_bottom).offset(10);
        make.width.equalTo(@(buttonW));
        make.height.equalTo(@(buttonH));
    }];
    
    [self.buttonView addSubview:self.yearButton];
    [self.yearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(25);
        make.top.equalTo(self.seasonButton.mas_bottom).offset(15);
        make.width.equalTo(@(buttonW));
        make.height.equalTo(@(buttonH));
    }];
    
    [self.buttonView addSubview:self.permanentButton];
    [self.permanentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-25);
        make.top.equalTo(self.seasonButton.mas_bottom).offset(15);
        make.width.equalTo(@(buttonW));
        make.height.equalTo(@(buttonH));
    }];
    
    
    
    [self.view addSubview:self.messageView];
    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.buttonView);
    }];
    
    [self.messageView addSubview:self.messageLabel];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageView).offset(30);
        make.left.equalTo(self.messageView).offset(10);
    }];
    
    [self.messageView addSubview:self.messageQQLabel];
    [self.messageQQLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.messageView).offset(15);
        make.top.equalTo(self.messageLabel.mas_bottom).offset(10);
    }];
    
    [self.messageView addSubview:self.messagewechatLabel];
    [self.messagewechatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.messageView).offset(15);
        make.top.equalTo(self.messageQQLabel.mas_bottom).offset(10);
    }];
    
}

-(UITextField *)cardTextField{
    if (!_cardTextField) {
        _cardTextField = [[UITextField alloc]init];
        _cardTextField.layer.masksToBounds = YES;
        _cardTextField.layer.cornerRadius = 2;
        _cardTextField.placeholder = @"请输入卡密";
        _cardTextField.font = [UIFont systemFontOfSize:14];
        _cardTextField.delegate = self;
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
        leftLabel.text = @"卡 密：";
        leftLabel.textAlignment = NSTextAlignmentRight;
        leftLabel.font = [UIFont systemFontOfSize:14];
        _cardTextField.leftView = leftLabel;
        _cardTextField.leftViewMode = UITextFieldViewModeAlways;
        _cardTextField.backgroundColor = [UIColor whiteColor];
    }
    return _cardTextField;
}

-(UIButton *)renewalFeeButton{
    if (!_renewalFeeButton) {
        _renewalFeeButton = [[UIButton alloc]init];
        [_renewalFeeButton setBackgroundColor:MCUIColorFromRGB(0x4161f3)];
        [_renewalFeeButton setTitle:@"续费" forState:UIControlStateNormal];
        [_renewalFeeButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _renewalFeeButton.layer.masksToBounds = YES;
        _renewalFeeButton.layer.cornerRadius = 2;
        
        [_renewalFeeButton addTarget:self action:@selector(clickRenewalFeeButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _renewalFeeButton;
}

-(UIView *)buttonView{
    if (!_buttonView) {
        _buttonView = [[UIView alloc]init];
        _buttonView.backgroundColor = [UIColor whiteColor];
    }
    return _buttonView;
}

-(UIView *)messageView{
    if (!_messageView) {
        _messageView = [[UIView alloc]init];
        _messageView.backgroundColor = [UIColor whiteColor];
        if ([AppDelegate sharedApplicationDelegate].userInfoModel.mastercode.length != 0) {
            NSString *firstString = [[AppDelegate sharedApplicationDelegate].userInfoModel.mastercode substringToIndex:1];
            if ([firstString isEqualToString:@"P"]) {
                _buttonView.hidden = NO;
                _messageView.hidden = YES;
            }else{
                _buttonView.hidden = YES;
                _messageView.hidden = NO;
            }
        }
    }
    return _messageView;
}

-(UIButton *)monthlyButton{
    if (!_monthlyButton) {
        _monthlyButton = [[UIButton alloc]init];
        [_monthlyButton setImage:[UIImage imageNamed:@"会员续费-月卡"] forState:UIControlStateNormal];
        [_monthlyButton addTarget:self action:@selector(clickMonthlyButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _monthlyButton;
}

-(UIButton *)seasonButton{
    if (!_seasonButton) {
        _seasonButton = [[UIButton alloc]init];
        [_seasonButton setImage:[UIImage imageNamed:@"会员续费-季卡"] forState:UIControlStateNormal];
        [_seasonButton addTarget:self action:@selector(clickSeasonButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seasonButton;
}

-(UIButton *)yearButton{
    if (!_yearButton) {
        _yearButton = [[UIButton alloc]init];
        [_yearButton setImage:[UIImage imageNamed:@"会员续费-年卡"] forState:UIControlStateNormal];
        [_yearButton addTarget:self action:@selector(clickYearButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _yearButton;
}

-(UIButton *)permanentButton{
    if (!_permanentButton) {
        _permanentButton = [[UIButton alloc]init];
        [_permanentButton setImage:[UIImage imageNamed:@"会员续费-永久"] forState:UIControlStateNormal];
        [_permanentButton addTarget:self action:@selector(clickPermanentButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _permanentButton;
}

-(UILabel *)messageQQLabel{
    if (!_messageQQLabel) {
        _messageQQLabel = [[UILabel alloc]init];
        _messageQQLabel.font = [UIFont systemFontOfSize:16];
        _messageQQLabel.textColor = [UIColor blackColor];
    }
    return _messageQQLabel;
}

-(UILabel *)messagewechatLabel{
    if (!_messagewechatLabel) {
        _messagewechatLabel = [[UILabel alloc]init];
        _messagewechatLabel.font = [UIFont systemFontOfSize:16];
        _messagewechatLabel.textColor = [UIColor blackColor];
    }
    return _messagewechatLabel;
}

-(UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc]init];
        _messageLabel.font = [UIFont systemFontOfSize:16];
        _messageLabel.textColor = [UIColor blackColor];
        _messageLabel.text = @"请找代理购买卡密，其联系方式如下：";
    }
    return _messageLabel;
}

-(UILabel *)kamiTitleLabel{
    if (!_kamiTitleLabel) {
        _kamiTitleLabel = [[UILabel alloc]init];
        _kamiTitleLabel.font = [UIFont systemFontOfSize:13];
        _kamiTitleLabel.textColor = [UIColor blackColor];
        _kamiTitleLabel.text = @"卡密充值";
    }
    return _kamiTitleLabel;
}

-(UILabel *)zaixianTitleLabel{
    if (!_zaixianTitleLabel) {
        _zaixianTitleLabel = [[UILabel alloc]init];
        _zaixianTitleLabel.font = [UIFont systemFontOfSize:13];
        _zaixianTitleLabel.textColor = [UIColor blackColor];
        _zaixianTitleLabel.text = @"在线充值";
    }
    return _zaixianTitleLabel;
}



-(void)clickRenewalFeeButton{
    [self.cardTextField resignFirstResponder];
    if (self.cardTextField.text.length == 0) {
        [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"请输入卡密"];
        return;
    }
    [CCView BSMBProgressHUD_bufferAndTextWithView:self.view andText:@"正在续费，你稍等！"];
    [CCMineManage MineCardExchangeWithCode:self.cardTextField.text andUid:[AppDelegate sharedApplicationDelegate].userInfoModel.Id completion:^(id resultDictionary, NSError *error) {
        [CCView BSMBProgressHUD_hideWith:self.view];
        if (error) {
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"网络错误，请稍后再试！"];
        }else{
            NSString *result = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"code"]];
            NSString *msg = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"msg"]];
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:msg];
            if ([result isEqualToString:@"1000"]) {
                self.cardTextField.text = nil;
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

-(void)clickMonthlyButton{
    CCWebViewController *wvc = [[CCWebViewController alloc]init];
    wvc.titleString = @"月卡";
    wvc.view.backgroundColor = [UIColor whiteColor];
    wvc.webViewType = WebViewTypeNome;
    NSString *url = [NSString stringWithFormat:@"%@%@",[AppDelegate sharedApplicationDelegate].fileConfigurationModel.cards.yueka_url,[AppDelegate sharedApplicationDelegate].userInfoModel.Id];
    url =  [url stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
    wvc.urlString = url;
    [self.navigationController pushViewController:wvc animated:YES];
}

-(void)clickSeasonButton{
    CCWebViewController *wvc = [[CCWebViewController alloc]init];
    wvc.titleString = @"季卡";
    wvc.view.backgroundColor = [UIColor whiteColor];
    wvc.webViewType = WebViewTypeNome;
    NSString *url = [NSString stringWithFormat:@"%@%@",[AppDelegate sharedApplicationDelegate].fileConfigurationModel.cards.jika_url,[AppDelegate sharedApplicationDelegate].userInfoModel.Id];
    url =  [url stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
    wvc.urlString = url;
    [self.navigationController pushViewController:wvc animated:YES];
}

-(void)clickYearButton{
    CCWebViewController *wvc = [[CCWebViewController alloc]init];
    wvc.titleString = @"年卡";
    wvc.view.backgroundColor = [UIColor whiteColor];
    wvc.webViewType = WebViewTypeNome;
    NSString *url = [NSString stringWithFormat:@"%@%@",[AppDelegate sharedApplicationDelegate].fileConfigurationModel.cards.nianka_url,[AppDelegate sharedApplicationDelegate].userInfoModel.Id];
    url =  [url stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
    wvc.urlString = url;
    [self.navigationController pushViewController:wvc animated:YES];
}

-(void)clickPermanentButton{
    CCWebViewController *wvc = [[CCWebViewController alloc]init];
    wvc.titleString = @"永久";
    wvc.view.backgroundColor = [UIColor whiteColor];
    wvc.webViewType = WebViewTypeNome;
    NSString *url = [NSString stringWithFormat:@"%@%@",[AppDelegate sharedApplicationDelegate].fileConfigurationModel.cards.zhongshenka_url,[AppDelegate sharedApplicationDelegate].userInfoModel.Id];
    url =  [url stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
    wvc.urlString = url;
    [self.navigationController pushViewController:wvc animated:YES];
}


-(void)initData{
    [CCView BSMBProgressHUD_bufferAndTextWithView:self.view andText:@"数据请求中..."];
    [CCMineManage MineAgentContactWithAid:[AppDelegate sharedApplicationDelegate].userInfoModel.selfcode Completion:^(id resultDictionary, NSError *error) {
        [CCView BSMBProgressHUD_hideWith:self.view];
        if (error) {
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"网络错误，请稍后再试！"];
        }else{
            NSString *result = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"code"]];
            if ([result isEqualToString:@"1000"]) {
                self.messageQQLabel.text = [NSString stringWithFormat:@"Q Q:%@",[resultDictionary objectForKey:@"qq"]];
                self.messagewechatLabel.text = [NSString stringWithFormat:@"微信:%@",[resultDictionary objectForKey:@"weixin"]];
            }else{
                NSString *msg = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"msg"]];
                [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:msg];
            }
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
