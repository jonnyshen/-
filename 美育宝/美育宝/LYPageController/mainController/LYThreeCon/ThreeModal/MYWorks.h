//
//  MYWorks.h
//  Page Demo
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYWorks : NSObject

@property (nonatomic, strong) NSArray *imageStr;

@property (nonatomic, strong) NSString *timeLb;


-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)dataWithDict:(NSDictionary*)dict;

@end
