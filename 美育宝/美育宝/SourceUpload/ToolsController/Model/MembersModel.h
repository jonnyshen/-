//
//  MembersModel.h
//  美育宝
//
//  Created by iOS程序员 on 2016/10/11.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MembersModel : NSObject
//小组成员
//成员ID
@property (nonatomic, strong) NSString *StudentCode;
//姓名
@property (nonatomic, strong) NSString *xm;

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)dataWithDict:(NSDictionary*)dict;
@end
