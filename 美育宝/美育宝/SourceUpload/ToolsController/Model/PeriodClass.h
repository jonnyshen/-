//
//  PeriodClass.h
//  美育宝
//
//  Created by iOS程序员 on 2016/10/10.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PeriodClass : NSObject
//课时
//标题
@property (nonatomic, strong) NSString *bt;
//编号
@property (nonatomic, strong) NSString *zbh;
//教材代码
@property (nonatomic, strong) NSString *jcdm;

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)dataWithDict:(NSDictionary*)dict;

@end
