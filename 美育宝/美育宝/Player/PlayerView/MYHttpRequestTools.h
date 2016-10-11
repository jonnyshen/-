//
//  MYHttpRequestTools.h
//  美育宝
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYHttpRequestTools : NSObject

//收藏课程
-(BOOL)collectClassWithRequestUrl:(NSString *)urlString andClassType:(NSString *)type;

//分享课程
- (void)shareClassWithRequest;

//参加课程
- (BOOL)takePartInClassWithRequest:(NSString*)urlString;


@end
