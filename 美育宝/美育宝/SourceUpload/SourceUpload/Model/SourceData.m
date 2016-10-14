//
//  SourceData.m
//  美育宝
//
//  Created by iOS程序员 on 2016/10/9.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import "SourceData.h"

@implementation SourceData

- (instancetype)initWithDict:(NSDictionary *)dict
{
    SourceData *data = [[SourceData alloc] init];
    
    data.scsj = dict[@"SCSJ"];
    data.mxdm = dict[@"MXDM"];
    data.fjmc = dict[@"FJMC"];
    data.zylj = dict[@"ZYLJ"];
    data.zylx = dict[@"ZYLX"];
    data.imgPath = dict[@"IMGPATH"];
    
    return data;
}

+(instancetype)dataWithDict:(NSDictionary *)dict
{
    return [[super alloc] initWithDict:dict];
}

@end
