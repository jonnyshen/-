//
//  MYMakeUpCompleteString.m
//  美育宝
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYMakeUpCompleteString.h"

@implementation MYMakeUpCompleteString
+ (NSString *)handleWithHeaderImage:(NSString *)imageStr headStr:(NSString *)headstr
{
    if ([imageStr isKindOfClass:[NSNull class]] || imageStr.length < 6) {
        return nil;
    }
    
    NSString *pieceImageStr = [imageStr substringWithRange:NSMakeRange(0, 6)];
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",headstr, pieceImageStr, imageStr];
    return imageUrl;
}
@end
