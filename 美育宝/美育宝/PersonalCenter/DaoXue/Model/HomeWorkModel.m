//
//  HomeWorkModel.m
//  美育宝
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "HomeWorkModel.h"

@implementation HomeWorkModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    HomeWorkModel *homeModel = [[HomeWorkModel alloc] init];
    homeModel.studentName = dict[@"XM"];
    homeModel.finishTime  = dict[@"WCSJ"];
    homeModel.finishType  = [dict[@"WCZT"] stringValue];
    homeModel.personImage = dict[@"PersonImage"];
    homeModel.studentID   = dict[@"XH"];
    
    
    return homeModel;
}

+ (instancetype)homeWorkDataWithDict:(NSDictionary *)dictor
{
    return [[self alloc] initWithDict:dictor];
}


@end
