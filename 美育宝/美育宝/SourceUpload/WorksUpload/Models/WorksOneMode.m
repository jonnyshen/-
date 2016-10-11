//
//  WorksOneMode.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/9.
//  Copyright © 2016年 Yonghang Liu. All rights reserved.
//

#import "WorksOneMode.h"

@implementation WorksOneMode

- (instancetype)initWithDict:(NSDictionary *)params
{
    WorksOneMode *oneMode = [[WorksOneMode alloc] init];
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dict in params[@"data"]) {
        
        oneMode.fjmc = dict[@"FJMC"];
        oneMode.zylx = dict[@"ZYLX"];
        oneMode.mxdm = dict[@"MXDM"];
        oneMode.imgPath = dict[@"IMGPATH"];
        oneMode.scsj = dict[@"SCSJ"];
        [arr addObject:oneMode];
    }
    self.workeData  = arr;
    
    return oneMode;
}

+ (instancetype)dataWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
