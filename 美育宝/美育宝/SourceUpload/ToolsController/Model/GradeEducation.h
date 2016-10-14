//
//  GradeEducation.h
//  美育宝
//
//  Created by iOS程序员 on 2016/10/10.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GradeEducation : NSObject
@property (nonatomic, strong) NSString *bh;

@property (nonatomic, strong) NSString *njbm;

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)dataWithDict:(NSDictionary*)dict;
@end
