//
//  PeriodClass.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/10.
//  Copyright © 2016年 Yonghang Liu. All rights reserved.
//

#import "PeriodClass.h"

@implementation PeriodClass
- (instancetype)initWithDict:(NSDictionary *)dict
{
    PeriodClass *stage = [[PeriodClass alloc] init];
    stage.bt = dict[@"BT"];
    stage.zbh = dict[@"ZBH"];
    stage.jcdm = dict[@"JCDM"];
    return stage;
}

+ (instancetype)dataWithDict:(NSDictionary *)dict
{
    return [[super alloc] initWithDict:dict];
}
@end
