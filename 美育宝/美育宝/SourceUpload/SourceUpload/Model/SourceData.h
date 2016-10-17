//
//  SourceData.h
//  美育宝
//
//  Created by iOS程序员 on 2016/10/9.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SourceData : NSObject
//
@property (nonatomic, strong) NSString *fjmc;//title
@property (nonatomic , strong) NSString *imgPath;//图片路径
@property (nonatomic, strong) NSString * zylx;//资源类型
@property (nonatomic , strong) NSString *mxdm;//cell ID
@property (nonatomic, strong) NSString * scsj;//time
@property (nonatomic, strong) NSString * zylj;


-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)dataWithDict:(NSDictionary*)dict;

@end
