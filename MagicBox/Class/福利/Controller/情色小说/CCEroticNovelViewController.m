//
//  CCEroticNovelViewController.m
//  MagicBox
//
//  Created by hello on 2018/11/16.
//  Copyright © 2018年 hello. All rights reserved.
//
#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height
#define pageMenuH 50
#define NaviH (screenH == 812 ? 88 : 64)
#define scrollViewHeight (screenH-NaviH-pageMenuH)
#import "CCEroticNovelViewController.h"
#import "CCEroticNovelClassViewController.h"
#import "SPPageMenu.h"
#import "CCBroadcastModel.h"

@interface CCEroticNovelViewController ()<SPPageMenuDelegate, UIScrollViewDelegate>
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *menuArray;
@property (nonatomic, weak) SPPageMenu *pageMenu;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation CCEroticNovelViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self initData];
}

-(void)initView{
    self.navigationItem.title = @"情色小说";
    self.navigationItem.leftBarButtonItem = self.customLeftItem;
    self.view.backgroundColor = MCUIColorFromRGB(0xe9e9e9);
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,pageMenuH, screenW, scrollViewHeight)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return  _scrollView;
}

- (void)stringMenuWithMenuArray:(NSArray *)menuArray{
    SPPageMenu *pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0,0, MCScreenWidth, 50) trackerStyle:SPPageMenuTrackerStyleLine];
    [pageMenu setItems:menuArray selectedItemIndex:0];
    pageMenu.delegate = self;
    pageMenu.bridgeScrollView = self.scrollView;
    [self.view addSubview:pageMenu];
    _pageMenu = pageMenu;
    
    [self.view addSubview:self.scrollView];
    
    
    for (int i = 0; i < self.dataArray.count; i++) {
        CCEroticNovelClassViewController *encvc = [[CCEroticNovelClassViewController alloc] init];
        encvc.broadcastModel = [self.dataArray objectAtIndex:i];
        [self addChildViewController:encvc];
    }
    
    if (self.pageMenu.selectedItemIndex < self.dataArray.count) {
        CCEroticNovelClassViewController *encvc = self.childViewControllers[self.pageMenu.selectedItemIndex];
        [self.scrollView addSubview:encvc.view];
        encvc.view.frame = CGRectMake(screenW*self.pageMenu.selectedItemIndex, 0, screenW, scrollViewHeight);
        self.scrollView .contentOffset = CGPointMake(screenW*self.pageMenu.selectedItemIndex, 0);
        self.scrollView .contentSize = CGSizeMake(self.dataArray.count*screenW, 0);
    }
}

-(void)initData{
    [CCView BSMBProgressHUD_bufferAndTextWithView:self.view andText:nil];
    [CCMineManage MineFictionClassificationCompletion:^(id resultDictionary, NSError *error) {
        [CCView BSMBProgressHUD_hideWith:self.view];
        if (error) {
            [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:@"网络错误，请稍后再试！"];
        }else{
            NSString *result = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"code"]];
            if ([result isEqualToString:@"1000"]) {
                NSArray *array = [resultDictionary objectForKey:@"data"];
                for (int i = 0; i < array.count; i ++) {
                    CCBroadcastModel *model = [CCBroadcastModel modelWithDictionary:[array objectAtIndex:i]];
                    [self.menuArray addObject:model.uname];
                    [self.dataArray addObject:model];
                }
                if (self.menuArray.count != 0) {
                    [self stringMenuWithMenuArray:self.menuArray];
                }
            }else{
                NSString *msg = [NSString stringWithFormat:@"%@",[resultDictionary objectForKey:@"msg"]];
                [CCView BSMBProgressHUD_onlyTextWithView:self.view andText:msg];
            }
        }
    }];
}

#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    NSLog(@"%zd",index);
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    if (!self.scrollView.isDragging) {
        if (labs(toIndex - fromIndex) >= 2) {
            [self.scrollView setContentOffset:CGPointMake(screenW * toIndex, 0) animated:NO];
        } else {
            [self.scrollView setContentOffset:CGPointMake(screenW * toIndex, 0) animated:YES];
        }
    }
    if (self.childViewControllers.count <= toIndex) {return;}
    UIViewController *targetViewController = self.childViewControllers[toIndex];
    if ([targetViewController isViewLoaded]) return;
    targetViewController.view.frame = CGRectMake(screenW * toIndex, 0, screenW, scrollViewHeight);
    [_scrollView addSubview:targetViewController.view];
    
}

-(NSMutableArray *)menuArray{
    if (!_menuArray) {
        _menuArray = [NSMutableArray array];
    }
    return _menuArray;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
