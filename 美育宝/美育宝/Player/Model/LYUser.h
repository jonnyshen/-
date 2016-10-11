//
//  LYUser.h
//  Page Demo
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LYUser;

@interface LYUser : NSObject<NSCoding>

@property (nonatomic, strong) NSString *passWd;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userCode;

+ (void)saveAccount:(LYUser *)account;

+ (LYUser *)account;

@end
