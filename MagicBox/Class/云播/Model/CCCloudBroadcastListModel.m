//
//  CCCloudBroadcastListModel.m
//  MagicBox
//
//  Created by hello on 2018/11/10.
//  Copyright © 2018年 hello. All rights reserved.
//

#import "CCCloudBroadcastListModel.h"
#import "CCJsonTool.h"

@implementation CCCloudBroadcastListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id":@"id"};
}

-(NSString *)ctime{
    return [CCJsonTool JsonToolDataTimeStrWithString:_ctime];
}

@end
