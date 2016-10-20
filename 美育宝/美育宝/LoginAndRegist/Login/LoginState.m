//
//  LoginState.m
//  Login
//
//  Created by  on 16/12/19.
//  Copyright (c) 2016年 . All rights reserved.
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
