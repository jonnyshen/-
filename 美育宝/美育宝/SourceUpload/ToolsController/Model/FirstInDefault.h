//
//  FirstInDefault.h
//  美育宝
//
//  Created by iOS程序员 on 2016/10/10.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirstInDefault : NSObject

//进入上传时后台默认显示数据
//年级
@property (nonatomic, strong) NSString *nj;

@property (nonatomic, strong) NSString *jyjd;
//教材代码
@property (nonatomic, strong) NSString *jcdm;
//科目
@property (nonatomic, strong) NSString *km;

@property (nonatomic, strong) NSString *dy;
//章编号
@property (nonatomic, strong) NSString *zbh;
//班号
@property (nonatomic, strong) NSString *bh;

-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)dataWithDict:(NSDictionary*)dict;
@end
