//
//  GroupNameModel.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/11.
//  Copyright © 2016年 Yonghang Liu. All rights reserved.
//

#import "GroupNameModel.h"

@implementation GroupNameModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    GroupNameModel *stage = [[GroupNameModel alloc] init];
    stage.identifier = [dict[@"Id"] stringValue];
    stage.name = dict[@"Name"];
    return stage;
}

+ (instancetype)dataWithDict:(NSDictionary *)dict
{
    return [[super alloc] initWithDict:dict];
}
@end
