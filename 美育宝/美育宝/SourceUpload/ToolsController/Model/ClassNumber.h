//
//  ClassNumber.h
//  美育宝
//
//  Created by iOS程序员 on 2016/10/11.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassNumber : NSObject
//班级
//班级号
@property (nonatomic, strong) NSString *bjh;
//班级名称
@property (nonatomic, strong) NSString *bjmc;

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)dataWithDict:(NSDictionary*)dict;
@end
