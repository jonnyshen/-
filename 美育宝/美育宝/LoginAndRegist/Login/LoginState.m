//
//  LoginState.m
//  Login
//
//  Created by zhuming on 15/12/19.
//  Copyright (c) 2015年 zhuming. All rights reserved.
//

#import "LoginState.h"

@implementation LoginState

+ (BOOL)isLogin{
    NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:@"LOGIN"];
    return login.intValue;
}

+ (void)setLogined{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"LOGIN"];
}

+ (void)setLoginOuted{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"LOGIN"];
}


@end
