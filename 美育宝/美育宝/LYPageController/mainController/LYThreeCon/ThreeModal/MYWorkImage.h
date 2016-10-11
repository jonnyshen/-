//
//  MYWorkImage.h
//  美育宝
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYWorkImage : NSObject

@property (nonatomic, strong) NSString *imageString;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageID;
@property (nonatomic, strong) NSString *videoImage;
- (instancetype)initWithDict:(NSDictionary *)dict;

+ (instancetype)workModelWithDictionary:(NSDictionary *)params;
@end
