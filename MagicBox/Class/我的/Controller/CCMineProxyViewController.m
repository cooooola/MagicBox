//
//  CCMineProxyViewController.m
//  MagicBox
//
//  Created by hello on 2018/11/15.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCMineProxyViewController.h"

@implementation CCMineProxyViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self initData];
}

-(void)initView{
    self.title = @"联系代理";
    self.navigationItem.leftBarButtonItem = self.customLeftItem;
    self.view.backgroundColor = MCUIColorFromRGB(0xe9e9e9);
    
}

-(void)initData{
    [CCView BSMBProgressHUD_bufferAndTextWithView:self.view andText:@"数据请求中..."];
    [CCMineManage MineAgentContactWithAid:[AppDelegate sharedApplicationDelegate].userInfoModel.selfcode Completion:^(id resultDictionary, NSError *error) {
        [CCView BSMBProgressHUD_hideWith:self.view];
        if (error) {
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"网络错误，请稍后再试！"];
        }else{
            NSString *result = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"result"]];
            if ([result isEqualToString:@"1000"]) {
                
            }else{
                NSString *msg = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"msg"]];
                [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:msg];
                __block typeof(self) weakSelf = self;
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5* NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController  popViewControllerAnimated:YES];
                });
            }
        }
    }];
}

@end
