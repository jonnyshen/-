//
//  LYUser.m
//  Page Demo
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "LYUser.h"

#define kFilePath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

@implementation LYUser

static LYUser *_account;
+ (void)saveAccount:(LYUser *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:kFilePath];
}

+ (LYUser *)account
{
    if (_account == nil) {
        _account = [NSKeyedUnarchiver unarchiveObjectWithFile:kFilePath];
    }
    return _account;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_passWd forKey:@"pass"];
    [aCoder encodeObject:_userName forKey:@"userName"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _passWd = [aDecoder decodeObjectForKey:@"pass"];
        _userName = [aDecoder decodeObjectForKey:@"userName"];
    }
    return self;
}


@end
