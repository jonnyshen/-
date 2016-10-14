//
//  FirstInDefault.h
//  美育宝
//
//  Created by iOS程序员 on 2016/10/10.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirstInDefault : NSObject
@property (nonatomic, strong) NSString *nj;

@property (nonatomic, strong) NSString *jyjd;
@property (nonatomic, strong) NSString *jcdm;

@property (nonatomic, strong) NSString *km;
@property (nonatomic, strong) NSString *dy;
@property (nonatomic, strong) NSString *zbh;
@property (nonatomic, strong) NSString *bh;

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)dataWithDict:(NSDictionary*)dict;
@end
