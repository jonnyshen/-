//
//  UnitsModel.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/10.
//  Copyright © 2016年 Yonghang Liu. All rights reserved.
//

#import "UnitsModel.h"

@implementation UnitsModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    UnitsModel *stage = [[UnitsModel alloc] init];
    stage.bt = dict[@"BT"];
    stage.zbh = dict[@"ZBH"];
    return stage;
}

+ (instancetype)dataWithDict:(NSDictionary *)dict
{
    return [[super alloc] initWithDict:dict];
}
@end
