//
//  CCWebViewController.m
//  MagicBox
//
//  Created by hello on 2018/11/8.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCWebViewController.h"
#import "CCWebFooterView.h"


@interface CCWebViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)CCWebFooterView *webFooterView;
@property(nonatomic,strong)NSString *currentUrl;
@end

@implementation CCWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.webViewType != WebViewTypeLottery) {
        self.navigationController.navigationBar.hidden = NO;
    }else{
        self.navigationController.navigationBar.hidden = YES;
        
    }
}

-(void)setUrlString:(NSString *)urlString{
    _urlString = urlString;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:request];
}

-(void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    self.navigationItem.title = titleString;
}

-(void)initView{
    if (self.webViewType != WebViewTypeLottery) {
        self.navigationItem.leftBarButtonItem = self.customLeftItem;
        self.navigationController.navigationBar.hidden = NO;
    }else{
        self.navigationController.navigationBar.hidden = YES;

    }
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        if (self->_webViewType == WebViewTypeNome) {
          make.bottom.equalTo(self.view);
        }else{
            make.bottom.equalTo(self.view).offset(-40);
        }
        
    }];
    
    [self.view addSubview:self.webFooterView];
    [self.webFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        if (self->_webViewType == WebViewTypeNome) {
            make.height.equalTo(@0);
        }else{
            make.height.equalTo(@40);
        }
    }];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
    [self.webView loadRequest:request];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)setWebViewType:(WebViewType)webViewType{
    _webViewType = webViewType;
    
    [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        if (self->_webViewType == WebViewTypeNome) {
            make.bottom.equalTo(self.view);
        }else{
            make.bottom.equalTo(self.view).offset(-40);
        }
        
    }];
    
    [self.view addSubview:self.webFooterView];
    [self.webFooterView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        if (self->_webViewType == WebViewTypeNome) {
            make.height.equalTo(@0);
            self.webFooterView.hidden = YES;
        }else{
            make.height.equalTo(@40);
        }
    }];
    
}

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.opaque = NO;
        _webView.delegate = self;
        [_webView setScalesPageToFit:YES];
    }
    return _webView;
}

-(CCWebFooterView *)webFooterView{
    if (!_webFooterView) {
        _webFooterView = [[CCWebFooterView alloc]init];
        
        __block typeof(self) WeakSelf = self;
        _webFooterView.clickReturnBtn = ^{
            [WeakSelf.webView goBack];
        };
        _webFooterView.clickPlayBtn = ^{
            NSString *beasUrl = @"http://vip.wbawh.cn/?url=";
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",beasUrl,WeakSelf.currentUrl]]];
            [WeakSelf.webView loadRequest:request];
        };
    }
    return _webFooterView;
}



#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType{
    self.currentUrl = request.URL.absoluteString;
    NSLog(@"%@",self.currentUrl);
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (NSString *)htmlAdjustWithPageWidth:(CGFloat )pageWidth html:(NSString *)html webView:(UIWebView *)webView{
    NSMutableString *str = [NSMutableString stringWithString:html];
    CGFloat initialScale = webView.frame.size.width/pageWidth;
    NSString *stringForReplace = [NSString stringWithFormat:@"<meta name=\"viewport\" content=\" initial-scale=%f, minimum-scale=0.1, maximum-scale=2.0, user-scalable=yes\"></head>",initialScale];
    NSRange range =  NSMakeRange(0, str.length);
    [str replaceOccurrencesOfString:@"</head>" withString:stringForReplace options:NSLiteralSearch range:range];
    return str;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
