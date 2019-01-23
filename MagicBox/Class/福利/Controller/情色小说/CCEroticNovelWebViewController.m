//
//  CCEroticNovelWebViewController.m
//  MagicBox
//
//  Created by hello on 2018/11/16.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCEroticNovelWebViewController.h"

@interface CCEroticNovelWebViewController()
@property(nonatomic,strong)UITextView *textView;

@end

@implementation CCEroticNovelWebViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self initData];
}

-(void)initView{
    self.navigationItem.leftBarButtonItem = self.customLeftItem;
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)setCloudBroadcastListModel:(CCCloudBroadcastListModel *)cloudBroadcastListModel{
    _cloudBroadcastListModel = cloudBroadcastListModel;
}


-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc]init];
        _textView.font = [UIFont systemFontOfSize:20];
        _textView.textColor = [UIColor blackColor];
        _textView.editable = NO;
    }
    return _textView;
}

-(void)initData{
    [CCView BSMBProgressHUD_bufferAndTextWithView:self.view andText:nil];
    [CCMineManage MineFictionContentWithFictionId:_cloudBroadcastListModel.Id completion:^(id resultDictionary, NSError *error) {
        [CCView BSMBProgressHUD_hideWith:self.view];
        if (error) {
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"网络错误，请稍后再试"];
        }else{
            NSString *code = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"code"]];
            if ([code isEqualToString:@"1000"]) {
                CCCloudBroadcastListModel *model = [CCCloudBroadcastListModel modelWithDictionary:[resultDictionary objectForKey:@"data"]];
                self.navigationItem.title = model.title;
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.lineSpacing = 10;// 字体的行间距
                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                             NSParagraphStyleAttributeName:paragraphStyle};
                self.textView.attributedText = [[NSAttributedString alloc] initWithString:model.conts attributes:attributes];
            }
        }
    }];
}


@end
