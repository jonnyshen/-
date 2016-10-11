//
//  FirstVCNewsModel.m
//  美育宝
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "FirstVCNewsModel.h"

@implementation FirstVCNewsModel

- (instancetype)initWithNewsDict:(NSDictionary *)dict
{
    FirstVCNewsModel *news = [[FirstVCNewsModel alloc] init];
    news.title = dict[@"InfoTitle"];
    news.newsID = [dict[@"InfoID"] stringValue];
    news.imagePath = dict[@"ImgPath"];
    news.detailHtml = dict[@"InfoUrl"];
    return news;
}

+ (instancetype)newsDataWithDict:(NSDictionary *)dictor
{
    return [[self alloc] initWithNewsDict:dictor];
}



@end
