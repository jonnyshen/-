//
//  FormValidator.m
//  Design
//
//  Created by fanghailong on 15/6/23.
//  Copyright (c) 2015年 ptteng. All rights reserved.
//

#import "FormValidator.h"

#define Width [UIScreen mainScreen].bounds.size.width/320.0
#define Height [UIScreen mainScreen].bounds.size.height/568.0

@implementation FormValidator

+ (NSString *)checkPassword:(NSString *)aPassword
{
    if (aPassword.length == 0) {
        return @"请输入密码";
    }
    if ( aPassword.length < 6 | aPassword.length > 16) {
        return @"密码长度应在6-16位，且不能含汉字或空格";
    }
    return  nil;
}

+ (NSString *)checkMobile:(NSString *)aMobile
{
    if ( aMobile.length == 0 ) {
        return @"请输入手机号";
    }
    if (aMobile.length != 11) {
        return @"请输入正确的手机号";
    }
    NSString *firstLetter = [aMobile substringToIndex:2];
    if (![firstLetter isEqualToString:@"15"] &&
        ![firstLetter isEqualToString:@"13"] &&
        ![firstLetter isEqualToString:@"18"] &&
        ![firstLetter isEqualToString:@"14"])
    {
        return @"请输入正确的手机号";
    }
    return nil;
}

+(NSString *)checkVerifyCode:(NSString *)verifyCode{
    if(verifyCode.length == 0){
        return @"请输入验证码";
    }
    if(verifyCode.length != 6){
        return @"请输入正确的验证码";
    }
    
    return nil;
}

+ (void) dimissAlert:(UIAlertView *)alert {
    if(alert)     {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}
+ (void)showAlertWithStr:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil  cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:2.0];
}
+(CGRect)rectWidthAndHeightWithStr:(NSString *)str AndFont:(CGFloat)fontFloat
{
    CGRect fcRect = [str boundingRectWithSize:CGSizeMake(150*Width, 1000*Height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontFloat*Width]} context:nil];
    return fcRect;
}
+(CGRect)rectWidthAndHeightWithStr:(NSString *)str AndFont:(CGFloat)fontFloat WithStrWidth:(CGFloat)widh
{
    CGRect fcRect = [str boundingRectWithSize:CGSizeMake(widh*Width, 1000*Height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontFloat*Width]} context:nil];
    return fcRect;
}
+(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}


@end
