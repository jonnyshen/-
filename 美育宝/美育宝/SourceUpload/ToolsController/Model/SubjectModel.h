//
//  SubjectModel.h
//  美育宝
//
//  Created by iOS程序员 on 2016/10/10.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubjectModel : NSObject
@property (nonatomic, strong) NSString *kch;

@property (nonatomic, strong) NSString *kcmc;

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)dataWithDict:(NSDictionary*)dict;
@end
