//
//  FlowerModel.h
//  Page Demo
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlowerModel : NSObject

@property (nonatomic, strong) NSString *winTime;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *teacher;
@property (nonatomic, strong) NSString *reason;
@property (nonatomic, strong) NSString *flowerNumber;


- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)flowerModelWithDictionary:(NSDictionary *)params;
@end
