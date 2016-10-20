//
//  WorksOneMode.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/9.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import "WorksOneMode.h"
#import "WorkTwoMode.h"

@implementation WorksOneMode

- (instancetype)initWithDict:(NSDictionary *)params
{
    WorksOneMode *oneMode = [[WorksOneMode alloc] init];
    
    
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dict in params[@"data"]) {
        
//        oneMode.fjmc = dict[@"FJMC"];
//        oneMode.zylx = dict[@"ZYLX"];
//        oneMode.mxdm = dict[@"MXDM"];
//        oneMode.imgPath = dict[@"IMGPATH"];
//        oneMode.scsj = dict[@"SCSJ"];
        
        WorkTwoMode *twomodel = [WorkTwoMode dataWithDict:dict];
        
        [arr addObject:twomodel];
    }
    self.workeData  = arr;
    
    return oneMode;
}

+ (instancetype)dataWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
