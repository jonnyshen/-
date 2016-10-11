//
//  MYWorkImage.m
//  美育宝
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYWorkImage.h"

@implementation MYWorkImage
- (instancetype)initWithDict:(NSDictionary *)dic
{
    MYWorkImage *imageModel = [[MYWorkImage alloc] init];
    imageModel.imageString = dic[@"ZYLJ"];
    imageModel.title       = dic[@"FJMC"];
    imageModel.imageID     = dic[@"MXDM"];
    imageModel.videoImage  = dic[@"IMGPATH"];
    
    return imageModel;
}

+ (instancetype)workModelWithDictionary:(NSDictionary *)params
{
    return [[self alloc] initWithDict:params];
}
@end
