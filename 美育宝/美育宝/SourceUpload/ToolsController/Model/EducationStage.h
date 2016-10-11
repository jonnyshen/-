//
//  EducationStage.h
//  美育宝
//
//  Created by iOS程序员 on 2016/10/10.
//  Copyright © 2016年 Yonghang Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EducationStage : NSObject

@property (nonatomic, strong) NSString *stageName;

@property (nonatomic, strong) NSString *stageIdentifier;

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)dataWithDict:(NSDictionary*)dict;

@end
