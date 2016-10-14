//
//  WorkTwoMode.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/9.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import "WorkTwoMode.h"

@implementation WorkTwoMode

- (instancetype)initWithDict:(NSDictionary *)dict
{
    WorkTwoMode *twoModel = [[WorkTwoMode alloc] init];
    
    twoModel.zylx = dict[@"ZYLX"];
    twoModel.mxdm = dict[@"MXDM"];
    twoModel.imgPath = dict[@"IMGPATH"];
    twoModel.scsj = dict[@"SCSJ"];
    
    return twoModel;
}

+ (instancetype)dataWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
    
}

@end
