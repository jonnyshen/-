//
//  TeachingMaterial.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/10.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import "TeachingMaterial.h"

@implementation TeachingMaterial
- (instancetype)initWithDict:(NSDictionary *)dict
{
    TeachingMaterial *stage = [[TeachingMaterial alloc] init];
    stage.jcdm = dict[@"JCDM"];
    stage.jcmc = dict[@"JCMC"];
    return stage;
}

+ (instancetype)dataWithDict:(NSDictionary *)dict
{
    return [[super alloc] initWithDict:dict];
}
@end
