//
//  UnitsModel.h
//  美育宝
//
//  Created by iOS程序员 on 2016/10/10.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitsModel : NSObject
//单元
@property (nonatomic, strong) NSString *bt;//标题

@property (nonatomic, strong) NSString *zbh;//单元ID

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)dataWithDict:(NSDictionary*)dict;
@end
