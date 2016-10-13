//
//  FirstInDefault.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/10.
//  Copyright © 2016年 Yonghang Liu. All rights reserved.
//

#import "FirstInDefault.h"

@implementation FirstInDefault
- (instancetype)initWithDict:(NSDictionary *)dict
{
    FirstInDefault *stage = [[FirstInDefault alloc] init];
    stage.nj = dict[@"NJ"];
    stage.km = dict[@"KM"];
    stage.dy = dict[@"DY"];
    stage.jyjd = dict[@"JYJD"];
    stage.bh = dict[@"BH"];
    stage.zbh = dict[@"ZBH"];
    stage.jcdm = dict[@"JCDM"];
    return stage;
}

+ (instancetype)dataWithDict:(NSDictionary *)dict
{
    return [[super alloc] initWithDict:dict];
}
@end
