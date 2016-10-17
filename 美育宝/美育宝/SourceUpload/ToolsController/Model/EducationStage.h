//
//  EducationStage.h
//  美育宝
//
//  Created by iOS程序员 on 2016/10/10.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EducationStage : NSObject
//教育阶段
@property (nonatomic, strong) NSString *stageName;//阶段名称

@property (nonatomic, strong) NSString *stageIdentifier;//阶段ID

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)dataWithDict:(NSDictionary*)dict;

@end
