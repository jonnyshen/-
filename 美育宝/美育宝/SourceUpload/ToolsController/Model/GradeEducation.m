//
//  GradeEducation.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/10.
//  Copyright © 2016年 Yonghang Liu. All rights reserved.
//

#import "GradeEducation.h"

@implementation GradeEducation
- (instancetype)initWithDict:(NSDictionary *)dict
{
    GradeEducation *stage = [[GradeEducation alloc] init];
    stage.njbm = dict[@"NJBM"];
    stage.njjd = dict[@"NJJD"];
    return stage;
}

+ (instancetype)dataWithDict:(NSDictionary *)dict
{
    return [[super alloc] initWithDict:dict];
}
@end
