//
//  LoginState.h
//  Login
//
//  Created by zhuming on 15/12/19.
//  Copyright (c) 2015年 zhuming. All rights reserved.
//  登录状态

#import <Foundation/Foundation.h>

@interface LoginState : NSObject
// YES 用户已经登录了
// NO  用户没有登录
+ (BOOL)isLogin;

// 设置用户为登录状态
+ (void)setLogined;
// 设置用户为未登录状态
+ (void)setLoginOuted;





@end
