//
//  FlowerModel.m
//  Page Demo
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "FlowerModel.h"

@implementation FlowerModel
- (instancetype)initWithDict:(NSDictionary *)params
{
    FlowerModel *flower = [[FlowerModel alloc] init];
    flower.name = params[@"XM"];
    flower.winTime = params[@"CJSJ"];
    flower.teacher = params[@"UserName"];
    flower.reason = params[@"Memo"];
    flower.flowerNumber = params[@"XHHS"];
    
    return flower;
}

+ (instancetype)flowerModelWithDictionary:(NSDictionary *)params
{
    return [[self alloc] initWithDict:params];
}
@end
