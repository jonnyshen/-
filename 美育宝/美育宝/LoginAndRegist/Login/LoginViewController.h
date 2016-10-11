//
//  LoginViewController.h
//  Page Demo
//
//  Created by apple on 16/4/29.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginDelegate <NSObject>

- (void)loginSuccess;

@end

@protocol LoginUserDefaultDelegate <NSObject>

- (void)getUserDefault:(NSUserDefaults *)userDefault;

@end


typedef NS_ENUM(NSInteger, LoginType) {
    LoginType_Normal = 0,
    LoginType_Parent,
    LoginType_Root,
};

@interface LoginViewController : UIViewController<UIAlertViewDelegate>


@property (nonatomic,assign)id<LoginDelegate>delegate;

@property (nonatomic,assign)id<LoginUserDefaultDelegate>userDefaults;

@property (nonatomic,assign)LoginType loginType;

//@property (nonatomic, strong) NSUserDefaults *userDefault;

// 用户没有登录就跳转到登录的VC
// 用户登录了就 return 跳出这个方法
+ (void)login:(UIViewController *)ctrl loginType:(LoginType)loginType;


@end
