//
//  NoticDetailModel.h
//  美育宝
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticDetailModel : NSObject

@property (nonatomic, strong) NSString *campTitle;
@property (nonatomic, strong) NSString *imageStr;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *times;
@property (nonatomic, assign) NSString * teacher;
@property (nonatomic, assign) NSString * school;
- (instancetype)initWithNoticDict:(NSDictionary *)dict;
+ (instancetype)noticDataWithDict:(NSDictionary *)dictor;

@end
