//
//  WorkTwoMode.h
//  美育宝
//
//  Created by iOS程序员 on 2016/10/9.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorkTwoMode : NSObject

@property (nonatomic, strong) NSString *fjmc;
@property (nonatomic , strong) NSString *imgPath;
@property (nonatomic, strong) NSString * zylx;
@property (nonatomic , strong) NSString *mxdm;
@property (nonatomic, strong) NSString * scsj;




-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)dataWithDict:(NSDictionary*)dict;

@end
