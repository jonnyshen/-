//
//  NoticDetailModel.m
//  美育宝
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "NoticDetailModel.h"

@implementation NoticDetailModel

- (instancetype)initWithNoticDict:(NSDictionary *)dict
{
    NoticDetailModel *noticModel = [[NoticDetailModel alloc] init];
    noticModel.campTitle = dict[@"XWBT"];
    noticModel.times     = dict[@"FBSJ"];
    noticModel.imageStr  = dict[@"SYZSPic"];
    noticModel.teacher   = dict[@"UerName"];
    noticModel.detail    = dict[@"XWNR"];
    noticModel.school    = dict[@"ZDMC"];
    
    return noticModel;
}

+ (instancetype)noticDataWithDict:(NSDictionary *)dictor
{
    return [[self alloc] initWithNoticDict:dictor];
}


@end
