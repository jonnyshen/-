//
//  MYSchool.h
//  Page Demo
//
//  Created by apple on 16/5/27.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYSchool : NSObject

@property (nonatomic, strong) NSString *campTitle;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *campUrl;
@property (nonatomic, strong) NSString *times;
@property (nonatomic, assign) NSString * teacher;
@property (nonatomic, assign) NSString * campDetail;

- (instancetype)initWithSchoolNewsDict:(NSDictionary *)dict;
+ (instancetype)schoolNewsDataWithDict:(NSDictionary *)dictor;

@end
