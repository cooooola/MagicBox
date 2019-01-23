//
//  CCViewController.m
//  SchoolMakeUp
//
//  Created by goulela on 16/9/26.
//  Copyright © 2016年 MC. All rights reserved.
//

#import "CCViewController.h"

@interface CCViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UILabel *numberMessagesLabel;
@property(nonatomic,strong)UIButton *noticeButton;


@end

@implementation CCViewController

#pragma mark - 生命周期
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

#pragma mark viewDidLoad
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = MCUIColorWhite;
    
    [CCView BSBarButtonItem_image_Who:self.navigationItem size:CGSizeMake(40, 40) target:self selected:@selector(leftItemClicked) image:@"Reuse_Back" isLeft:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    [self initView];
}

-(void)initView{
    self.backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    self.backgroundImageView.userInteractionEnabled = YES;
    self.backgroundImageView.image = [UIImage imageNamed:@"yxtd-bj"];
    [self.view addSubview:self.backgroundImageView];
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (void)leftItemClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setIsShow404View:(BOOL)isShow404View {
    if (isShow404View == YES) {
        [self.view addSubview:self.abnormalView];
        [self.abnormalView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    } else {
        [self.abnormalView removeFromSuperview];
    }
}

- (void)setIsShowEmptyView:(BOOL)isShowEmptyView {
    if (isShowEmptyView == YES) {
        [self.view addSubview:self.emptyView];
        [self.emptyView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    } else {
        [self.emptyView removeFromSuperview];
    }
}


- (void)KKAbnormalNetworkView_hitReloadButtonMethod {

}




- (CCAbnormalNetworkView *)abnormalView {
    if (_abnormalView == nil) {
        self.abnormalView = [[CCAbnormalNetworkView alloc] init];
        self.abnormalView.backgroundColor = MCUIColorWhite;
        self.abnormalView.customDelegate = self;
    } return _abnormalView;
}

- (CCEmptyDataView *)emptyView {
    if (_emptyView == nil) {
        _emptyView = [[CCEmptyDataView alloc] init];
    }
    return _emptyView;
}



- (UIBarButtonItem *)customLeftItem {
    if (_customLeftItem == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 42, 30);
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setImage:[UIImage imageNamed:@"向左"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pushToServiceController) forControlEvents:UIControlEventTouchUpInside];
        btn.adjustsImageWhenHighlighted = NO;

        _customLeftItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    }
    return _customLeftItem;
}

-(UIBarButtonItem *)collectionButtonItem{
    if(!_collectionButtonItem){
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, 0, 65, 28);
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = 14;
        
        UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"收藏"]];
        imageview.centerY = view.centerY;
        imageview.centerX = view.centerX-15;
        [view addSubview:imageview];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(imageview.right+5, 0, 40, 28)];
        label.font = [UIFont systemFontOfSize:13];
        label.text = @"收藏";
        [view addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = view.bounds;
        [btn addTarget:self action:@selector(pushToCollectionViewController) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        _collectionButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    }
    return _collectionButtonItem;
}

-(UIButton *)returnBurron{
    if (!_returnBurron) {
        _returnBurron = [[UIButton alloc]init];
        [_returnBurron setImage:[UIImage imageNamed:@"xiangzuo"] forState:UIControlStateNormal];
        [_returnBurron addTarget:self action:@selector(pushToServiceController) forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnBurron;
}



- (void)CCAbnormalNetworkView_hitReloadButtonMethod{
    
}

-(void)pushToServiceController{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pushToCollectionViewController{
    
}
@end

