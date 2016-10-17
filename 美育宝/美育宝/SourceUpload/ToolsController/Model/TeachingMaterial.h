//
//  TeachingMaterial.h
//  美育宝
//
//  Created by iOS程序员 on 2016/10/10.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeachingMaterial : NSObject
//教材版本
@property (nonatomic, strong) NSString *jcmc;//教材名称

@property (nonatomic, strong) NSString *jcdm;//教材代码

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)dataWithDict:(NSDictionary*)dict;
@end
