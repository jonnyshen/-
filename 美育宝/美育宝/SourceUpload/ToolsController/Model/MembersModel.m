//
//  MembersModel.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/11.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import "MembersModel.h"

@implementation MembersModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    MembersModel *stage = [[MembersModel alloc] init];
    stage.StudentCode = dict[@"StudentCode"];
    stage.xm = dict[@"XM"];
    return stage;
}

+ (instancetype)dataWithDict:(NSDictionary *)dict
{
    return [[super alloc] initWithDict:dict];
}
@end
