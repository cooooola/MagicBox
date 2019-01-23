//
//  CCWebViewController.h
//  MagicBox
//
//  Created by hello on 2018/11/8.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCViewController.h"

@interface CCWebViewController : CCViewController
@property(nonatomic,assign)WebViewType webViewType;
@property(nonatomic,strong)NSString *urlString;
@property(nonatomic,strong)NSString *titleString;
@end
