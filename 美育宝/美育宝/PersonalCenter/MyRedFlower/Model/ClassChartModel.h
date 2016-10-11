//
//  ClassChartModel.h
//  Page Demo
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassChartModel : NSObject

@property (nonatomic, strong) NSString *flowerNumber;
@property (nonatomic, strong) NSString *stuName;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *flowerId;
@property (nonatomic, strong) NSString *rank;


- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)flowerModelWithDictionary:(NSDictionary *)params;
@end
