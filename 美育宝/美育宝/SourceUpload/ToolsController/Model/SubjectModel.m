//
//  SubjectModel.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/10.
//  Copyright © 2016年 Yonghang Liu. All rights reserved.
//

#import "SubjectModel.h"

@implementation SubjectModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    SubjectModel *stage = [[SubjectModel alloc] init];
    stage.kch = dict[@"KCH"];
    stage.kcmc = dict[@"KCMC"];
    return stage;
}

+ (instancetype)dataWithDict:(NSDictionary *)dict
{
    return [[super alloc] initWithDict:dict];
}
@end
