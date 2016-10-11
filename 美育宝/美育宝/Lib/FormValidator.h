//
//  FormValidator.h
//  Design
//
//  Created by fanghailong on 15/6/23.
//  Copyright (c) 2015年 ptteng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FormValidator : NSObject<UIAlertViewDelegate>


+(UIColor *) randomColor;
+(NSString *)checkPassword:(NSString *)aPassword;

+(NSString *)checkMobile:(NSString *)aMobile;

+(NSString *)checkVerifyCode:(NSString *)verifyCode;
+ (void)showAlertWithStr:(NSString *)message;
+(CGRect)rectWidthAndHeightWithStr:(NSString *)str AndFont:(CGFloat)fontFloat;
+(CGRect)rectWidthAndHeightWithStr:(NSString *)str AndFont:(CGFloat)fontFloat WithStrWidth:(CGFloat)widh;
@end
