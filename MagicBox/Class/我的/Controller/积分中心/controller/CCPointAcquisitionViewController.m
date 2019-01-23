//
//  CCPointAcquisitionViewController.m
//  MagicBox
//
//  Created by hello on 2018/11/15.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCPointAcquisitionViewController.h"

@interface CCPointAcquisitionViewController()
@property(nonatomic,strong)UILabel *urlTitleLabel;
@property(nonatomic,strong)UIButton *urlButton;
@property(nonatomic,strong)UILabel *urlLabel;

@property(nonatomic,strong)UILabel *codeTitleLabel;
@property(nonatomic,strong)UIButton *codeButton;
@property(nonatomic,strong)UILabel *codeLabel;

@property(nonatomic,strong)UILabel *QRcodeLabel;
@property(nonatomic,strong)UIButton *QRcodeButton;
@end

@implementation CCPointAcquisitionViewController

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)initView{
    self.title = @"获取积分";
    self.navigationItem.leftBarButtonItem = self.customLeftItem;
    self.view.backgroundColor = MCUIColorFromRGB(0xe9e9e9);
    
    [self.view addSubview:self.urlTitleLabel];
    [self.urlTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(50);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    [self.view addSubview:self.urlButton];
    [self.urlButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.urlTitleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@40);
    }];
    
    [self.view addSubview:self.urlLabel];
    [self.urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.urlButton.mas_bottom).offset(5);
        make.centerX.equalTo(self.urlButton);
    }];
    
    [self.view addSubview:self.codeTitleLabel];
    [self.codeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.urlLabel.mas_bottom).offset(40);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    [self.view addSubview:self.codeButton];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTitleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.height.equalTo(@40);
    }];
    
    [self.view addSubview:self.codeLabel];
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeButton.mas_bottom).offset(5);
        make.centerX.equalTo(self.codeButton);
    }];
    
    [self.view addSubview:self.QRcodeLabel];
    [self.QRcodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeLabel.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(20);
    }];
    [self.view addSubview:self.QRcodeButton];
    [self.QRcodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.QRcodeLabel.mas_bottom).offset(10);
        make.width.height.equalTo(@150);
        make.centerX.equalTo(self.view);
    }];

}

-(UILabel *)urlTitleLabel{
    if (!_urlTitleLabel) {
        _urlTitleLabel = [[UILabel alloc]init];
        _urlTitleLabel.textColor = [UIColor orangeColor];
        _urlTitleLabel.font = [UIFont systemFontOfSize:15];
        _urlTitleLabel.numberOfLines = 2;
        _urlTitleLabel.text = @"1､分享以下网址给好友，好友成功下载，奖励1积分";
    }
    return _urlTitleLabel;
}

-(UILabel *)codeTitleLabel{
    if (!_codeTitleLabel) {
        _codeTitleLabel = [[UILabel alloc]init];
        _codeTitleLabel.textColor = [UIColor orangeColor];
        _codeTitleLabel.font = [UIFont systemFontOfSize:15];
        _codeTitleLabel.numberOfLines = 2;
        _codeTitleLabel.text = @"2､好友使用您的推荐码成功注册，资励15积分";
    }
    return _codeTitleLabel;
}

-(UIButton *)urlButton{
    if (!_urlButton) {
        _urlButton = [[UIButton alloc]init];
        if ([AppDelegate sharedApplicationDelegate].fileConfigurationModel.share.app_ios.length == 0) {
           [_urlButton setTitle:@"未获取到分享网址，请稍后再试！" forState:UIControlStateNormal];
        }else{
            [_urlButton setTitle:[NSString stringWithFormat:@"%@%@",[AppDelegate sharedApplicationDelegate].fileConfigurationModel.share.app_ios,[AppDelegate sharedApplicationDelegate].userInfoModel.selfcode] forState:UIControlStateNormal];
        }
        
        [_urlButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_urlButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_urlButton addTarget:self action:@selector(clickUrlButton) forControlEvents:UIControlEventTouchUpInside];
        _urlButton.layer.masksToBounds = YES;
        _urlButton.layer.borderWidth = 1;
        _urlButton.layer.borderColor = [[UIColor colorWithRed:19/255.0 green:150/255.0 blue:239/255.0 alpha:1] CGColor];
        _urlButton.layer.cornerRadius = 4;
    }
    return _urlButton;
}

-(UIButton *)codeButton{
    if (!_codeButton) {
        _codeButton = [[UIButton alloc]init];
        [_codeButton setTitle:[NSString stringWithFormat:@"%@",[AppDelegate sharedApplicationDelegate].userInfoModel.selfcode] forState:UIControlStateNormal];
        [_codeButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_codeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_codeButton addTarget:self action:@selector(clickCodeButton) forControlEvents:UIControlEventTouchUpInside];
        _codeButton.layer.masksToBounds = YES;
        _codeButton.layer.borderWidth = 1;
        _codeButton.layer.borderColor = [[UIColor colorWithRed:19/255.0 green:150/255.0 blue:239/255.0 alpha:1] CGColor];
        _codeButton.layer.cornerRadius = 4;
    }
    return _codeButton;
}

-(UILabel *)urlLabel{
    if (!_urlLabel) {
        _urlLabel = [[UILabel alloc]init];
        _urlLabel.textColor = [UIColor grayColor];
        _urlLabel.font = [UIFont systemFontOfSize:15];
        _urlLabel.text = @"点击复制";
    }
    return _urlLabel;
}

-(UILabel *)codeLabel{
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc]init];
        _codeLabel.textColor = [UIColor grayColor];
        _codeLabel.font = [UIFont systemFontOfSize:15];
        _codeLabel.text = @"点击复制";
    }
    return _codeLabel;
}

-(UIButton *)QRcodeButton{
    if (!_QRcodeButton) {
        _QRcodeButton = [[UIButton alloc]init];
        [_QRcodeButton setImage: [self generateQRcodeWithUrlstring:[NSString stringWithFormat:@"%@%@",[AppDelegate sharedApplicationDelegate].fileConfigurationModel.share.app_ios,[AppDelegate sharedApplicationDelegate].userInfoModel.selfcode]] forState:UIControlStateNormal];
        [_QRcodeButton addTarget:self action:@selector(clickQRcodeButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _QRcodeButton;
}

-(UILabel *)QRcodeLabel{
    if (!_QRcodeLabel) {
        _QRcodeLabel = [[UILabel alloc]init];
        _QRcodeLabel.textColor = [UIColor orangeColor];
        _QRcodeLabel.font = [UIFont systemFontOfSize:15];
        _QRcodeLabel.text = @"3､您的专属二维码，点击保存";
        _QRcodeLabel.font = [UIFont systemFontOfSize:15];
    }
    return _QRcodeLabel;
}

-(void)clickUrlButton{
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = self.urlButton.titleLabel.text;
    [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"已复制"];
}

-(void)clickCodeButton{
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = self.codeButton.titleLabel.text;
    [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"已复制"];
}

-(void)clickQRcodeButton{
    UIImageWriteToSavedPhotosAlbum([self generateQRcodeWithUrlstring:[NSString stringWithFormat:@"%@%@",[AppDelegate sharedApplicationDelegate].fileConfigurationModel.share.app_ios,[AppDelegate sharedApplicationDelegate].userInfoModel.selfcode]], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(error){
        [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"保存图片失败"];
    }else{
        [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"保存图片成功"];
    }
}


-(UIImage *)generateQRcodeWithUrlstring:(NSString *)urlstring{
    // 1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    
    NSData *data = [urlstring dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    UIImage *QRcodeImage = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:150];
    return QRcodeImage;
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
