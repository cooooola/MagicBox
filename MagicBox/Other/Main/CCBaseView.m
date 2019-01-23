//
//  CCBaseView.m
//  SmallGames
//
//  Created by hello on 2018/9/19.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCBaseView.h"

@implementation CCBaseView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.backgroundColor = [UIColor whiteColor];
}

@end
