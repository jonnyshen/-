//
//  GroupNameModel.h
//  美育宝
//
//  Created by iOS程序员 on 2016/10/11.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupNameModel : NSObject
@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, strong) NSString *name;

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)dataWithDict:(NSDictionary*)dict;
@end
