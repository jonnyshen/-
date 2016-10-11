//
//  UnitsModel.h
//  美育宝
//
//  Created by iOS程序员 on 2016/10/10.
//  Copyright © 2016年 Yonghang Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnitsModel : NSObject
@property (nonatomic, strong) NSString *bt;

@property (nonatomic, strong) NSString *zbh;

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)dataWithDict:(NSDictionary*)dict;
@end
