//
//  CCCollectionViewCell.m
//  MagicBox
//
//  Created by hello on 2018/11/5.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCCollectionViewCell.h"

@implementation CCCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}


-(instancetype)init{
    if (self == [super init]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    
}

@end
