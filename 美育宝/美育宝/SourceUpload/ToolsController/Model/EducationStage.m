//
//  EducationStage.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/10.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import "EducationStage.h"

@implementation EducationStage

- (instancetype)initWithDict:(NSDictionary *)dict
{
    EducationStage *stage = [[EducationStage alloc] init];
    stage.stageName = dict[@"ZDMC"];
    stage.stageIdentifier = dict[@"ZDID"];
    return stage;
}

+ (instancetype)dataWithDict:(NSDictionary *)dict
{
    return [[super alloc] initWithDict:dict];
}

@end
