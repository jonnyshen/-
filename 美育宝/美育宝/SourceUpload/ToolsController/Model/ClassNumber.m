//
//  ClassNumber.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/11.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import "ClassNumber.h"

@implementation ClassNumber
- (instancetype)initWithDict:(NSDictionary *)dict
{
    ClassNumber *stage = [[ClassNumber alloc] init];
    stage.bjh = dict[@"BJH"];
    stage.bjmc = dict[@"BJMC"];
    return stage;
}

+ (instancetype)dataWithDict:(NSDictionary *)dict
{
    return [[super alloc] initWithDict:dict];
}
@end
