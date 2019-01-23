//
//  CCViewController.h
//  SchoolMakeUp
//
//  Created by goulela on 16/9/26.
//  Copyright © 2016年 MC. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface CCViewController : UIViewController<CCAbnormalNetworkViewDelegate>
@property(nonatomic,strong)UIImageView *backgroundImageView; //背景view
@property(nonatomic,strong)CCAbnormalNetworkView * abnormalView;//无网界面
@property(nonatomic,strong)CCEmptyDataView * emptyView;//空白界面
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)BOOL isShow404View;
@property(nonatomic,assign)BOOL isShowEmptyView;
@property(nonatomic,strong)UIBarButtonItem *customLeftItem;
@property(nonatomic,strong)UIBarButtonItem *doubtButtonItem;

@property(nonatomic,strong)UIBarButtonItem *collectionButtonItem;
@property(nonatomic,strong)UIButton *returnBurron;

-(void)initView;

@end
