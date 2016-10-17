//
//  SubjectModel.h
//  美育宝
//
//  Created by iOS程序员 on 2016/10/10.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubjectModel : NSObject

//科目
@property (nonatomic, strong) NSString *kch;//课程号

@property (nonatomic, strong) NSString *kcmc;//课程名称

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)dataWithDict:(NSDictionary*)dict;
@end
