//
//  ClassChartModel.m
//  Page Demo
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "ClassChartModel.h"

@implementation ClassChartModel
- (instancetype)initWithDict:(NSDictionary *)parms
{
    ClassChartModel *classModel = [[ClassChartModel alloc] init];
    classModel.flowerId  = parms[@"XH"];
    classModel.className = parms[@"BJMC"];
    classModel.stuName   = parms[@"XM"];
    classModel.rank      = parms[@"PM"];
    classModel.flowerNumber = [parms[@"HHSum"] stringValue];
    return classModel;
}

+ (instancetype)flowerModelWithDictionary:(NSDictionary *)params
{
    return [[self alloc] initWithDict:params];
}
@end
