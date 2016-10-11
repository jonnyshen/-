//
//  HomeWorkModel.h
//  美育宝
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeWorkModel : NSObject


@property (nonatomic, strong) NSString *studentName;
@property (nonatomic, strong) NSString *finishType;
@property (nonatomic, strong) NSString *personImage;
@property (nonatomic, strong) NSString *finishTime;
@property (nonatomic, strong) NSString *studentID;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)homeWorkDataWithDict:(NSDictionary *)dictor;

@end
