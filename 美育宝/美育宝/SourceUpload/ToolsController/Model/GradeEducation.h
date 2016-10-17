//
//  GradeEducation.h
//  美育宝
//
//  Created by iOS程序员 on 2016/10/10.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GradeEducation : NSObject

//年级model
@property (nonatomic, strong) NSString *bh;//年级编号

@property (nonatomic, strong) NSString *njbm;//年级名称

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)dataWithDict:(NSDictionary*)dict;
@end
