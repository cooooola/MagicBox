//
//  CCPersonalSecurityPrivacyViewController.m
//  SmallGames
//
//  Created by hello on 2018/9/21.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCPersonalSecurityPrivacyViewController.h"
#import "CCPasswordViewController.h"
#import "CCPersonalCell.h"

@interface CCPersonalSecurityPrivacyViewController ()
@property(nonatomic,strong)NSArray *dataArray;

@end

@implementation CCPersonalSecurityPrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)initView{
    [super initView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"安全隐私";
    self.navigationItem.leftBarButtonItem = self.customLeftItem;
    self.dataArray = @[@"登录密码"];
    self.backgroundImageView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    self.backgroundImageView.image = nil;
    self.backgroundImageView.backgroundColor = MCUIColorFromRGB(0xF9F9F9);

    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[CCPersonalCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CCPersonalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.cellTitle = [NSString stringWithFormat:@"%@",[self.dataArray objectAtIndex:indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 5)];
    return sectionHeaderView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CCPasswordViewController *vc = [[CCPasswordViewController alloc]init];
    vc.viewTaye = @"2";
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
