//
//  MYSchool.m
//  Page Demo
//
//  Created by apple on 16/5/27.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYSchool.h"

@implementation MYSchool

- (instancetype)initWithSchoolNewsDict:(NSDictionary *)params
{
    MYSchool *school = [[MYSchool alloc] init];
    school.imagePath = params[@"ImgPath"];
    school.campTitle = params[@"InfoTitle"];
    
    school.teacher = params[@"UserName"];
    school.times = params[@"PubTime"];
    school.campUrl    = params[@"InfoUrl"];
    
    return school;
}

+ (instancetype)schoolNewsDataWithDict:(NSDictionary *)dictor
{
    return [[self alloc] initWithSchoolNewsDict:dictor];
}


@end
