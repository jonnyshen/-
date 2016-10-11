//
//  SHInvoker.m
//  易林Video
//
//  Created by beijingduanluo on 15/11/23.
//  Copyright © 2015年 beijingduanluo. All rights reserved.
//

#import "SHInvoker.h"
#define canUseObj(str) ( (str != nil) && ![str isKindOfClass:[NSNull class]] )
@implementation SHInvoker
//保存数据到NSUserDefaults
+(void)saveUserInfo:(NSDictionary *)userinfo
{
    
    /*
     Amount = "<null>";
     BusibussId =     (
     1001
     );
     city = "\U5317\U4eac\U5e02";
     cityId = 10201;
     phoneNo = 13811247642;
     status = 1;
     userId = 1000;
     
     #define SHInvokerUserInfoAmount @"Amount"  总数
     #define SHInvokerUserInfoBusibussId @"BusibussId"
     #define SHInvokerUserInfoCity @"city"  城市
     #define SHInvokerUserInfoCityId @"cityId" 城市ID
     #define SHInvokerUserInfoPhoneNo @"phoneNo" 电话
     #define SHInvokerUserInfoStatus @"status"  身份
     #define SHInvokerUserInfoUserId @"userId"  用户ID
     */
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
    
    if (canUseObj([userinfo objectForKey:SHInvokerUserInfoAmount])) {
        [userDefault setObject:[userinfo objectForKey:SHInvokerUserInfoAmount] forKey:SHInvokerUserInfoAmount];
    }else{
        [userDefault setObject:@"0" forKey:SHInvokerUserInfoAmount];
    }
    if (canUseObj([userinfo objectForKey:SHInvokerUserInfoBusibussId])) {
        [userDefault setObject:[userinfo objectForKey:SHInvokerUserInfoBusibussId] forKey:SHInvokerUserInfoBusibussId];
    }else{
        [userDefault setObject:[NSArray arrayWithObjects:@"", nil] forKey:SHInvokerUserInfoBusibussId];
    }
    if (canUseObj([userinfo objectForKey:SHInvokerUserInfoCity])) {
        [userDefault setObject:[userinfo objectForKey:SHInvokerUserInfoCity] forKey:SHInvokerUserInfoCity];
    }else{
        [userDefault setObject:@"" forKey:SHInvokerUserInfoCity];
    }
    
    if (canUseObj([userinfo objectForKey:SHInvokerUserInfoCityId])) {
        [userDefault setObject:[userinfo objectForKey:SHInvokerUserInfoCityId] forKey:SHInvokerUserInfoCityId];
    }else{
        [userDefault setObject:@"" forKey:SHInvokerUserInfoCityId];
    }
    
    if (canUseObj([userinfo objectForKey:SHInvokerUserInfoPhoneNo])) {
        [userDefault setObject:[userinfo objectForKey:SHInvokerUserInfoPhoneNo] forKey:SHInvokerUserInfoPhoneNo];
    }else{
        [userDefault setObject:@"" forKey:SHInvokerUserInfoPhoneNo];
    }
    
    if (canUseObj([userinfo objectForKey:SHInvokerUserInfoStatus])) {
        [userDefault setObject:[userinfo objectForKey:SHInvokerUserInfoStatus] forKey:SHInvokerUserInfoStatus];
    }else{
        [userDefault setObject:@"" forKey:SHInvokerUserInfoStatus];
    }
    
    if (canUseObj([userinfo objectForKey:SHInvokerUserInfoUserId])) {
        [userDefault setObject:[userinfo objectForKey:SHInvokerUserInfoUserId] forKey:SHInvokerUserInfoUserId];
    }else{
        [userDefault setObject:@"0" forKey:SHInvokerUserInfoUserId];
    }
    if (canUseObj([userinfo objectForKey:SHInvokerUserInfoAdd])) {
        [userDefault setObject:[userinfo objectForKey:SHInvokerUserInfoAdd] forKey:SHInvokerUserInfoAdd];
    }
    else{
        [userDefault setObject:@"" forKey:SHInvokerUserInfoAdd];
    }
    if (canUseObj([userinfo objectForKey:SHInvokerUserInfolocationSign])) {
        [userDefault setObject:[userinfo objectForKey:SHInvokerUserInfolocationSign] forKey:SHInvokerUserInfolocationSign];
    }else{
        [userDefault setObject:@"" forKey:SHInvokerUserInfolocationSign];
    }
    
    
    //这里建议同步存储到磁盘中，但是不是必须的
    [userDefault synchronize];
    
}
//从NSUserDefaults中读取数据
+ (NSDictionary*)getUserInfo {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary * returnDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [userDefault objectForKey:SHInvokerUserInfoAmount],SHInvokerUserInfoAmount,
                                 [userDefault objectForKey:SHInvokerUserInfoBusibussId],
                                 SHInvokerUserInfoBusibussId,
                                 [userDefault objectForKey:SHInvokerUserInfoCity],
                                 SHInvokerUserInfoCity,
                                 [userDefault objectForKey:SHInvokerUserInfoCityId],
                                 SHInvokerUserInfoCityId,
                                 [userDefault objectForKey:SHInvokerUserInfoPhoneNo],
                                 SHInvokerUserInfoPhoneNo,
                                 [userDefault objectForKey:SHInvokerUserInfoStatus],
                                 SHInvokerUserInfoStatus,
                                 [userDefault objectForKey:SHInvokerUserInfoUserId],
                                 SHInvokerUserInfoUserId,
                                 [userDefault objectForKey:SHInvokerUserInfoAdd],
                                 SHInvokerUserInfoAdd,
                                 [userDefault objectForKey:SHInvokerUserInfolocationSign],SHInvokerUserInfolocationSign,
                                 nil];
    
    return returnDict;
}


//退出登录的时候清除数据
+ (void)clearUserInfo {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:nil forKey:SHInvokerUserInfoAmount];
    [userDefault setObject:nil forKey:SHInvokerUserInfoCity];
    [userDefault setObject:nil forKey:SHInvokerUserInfoCityId];
    [userDefault setObject:nil forKey:SHInvokerUserInfoPhoneNo];
    [userDefault setObject:nil forKey:SHInvokerUserInfoStatus];
    [userDefault setObject:nil forKey:SHInvokerUserInfoUserId];
    [userDefault setObject:nil forKey:SHInvokerUserInfoBusibussId];
    
    [userDefault setObject:nil forKey:SHInvokerUserInfolocationSign];
    
    [userDefault synchronize];
}

//判断是否登录
+ (BOOL)isLogined{
    BOOL result = NO;
    if ([[self getUserInfo] objectForKey:SHInvokerUserInfoUserId] && [[[self getUserInfo]objectForKey:SHInvokerUserInfoUserId] integerValue]!=0) {
        result = YES;
    }
    return result;
}

//获取当前版本
+ (NSString *)currentVersionString{
    return  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
