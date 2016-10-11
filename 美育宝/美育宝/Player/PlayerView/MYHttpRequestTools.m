//
//  MYHttpRequestTools.m
//  美育宝
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYHttpRequestTools.h"
#import "AFNetworking.h"


@implementation MYHttpRequestTools

- (BOOL)collectClassWithRequestUrl:(NSString *)urlString andClassType:(NSString *)type
{
    __block BOOL issuccess;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject[@"issuccess"] isEqualToString:@"true"]) {
            issuccess = YES;
        } else {
            issuccess = NO;
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    return issuccess;
}

- (void)shareClassWithRequest
{
    
}

- (BOOL)takePartInClassWithRequest:(NSString *)urlString
{
    __block BOOL issuccess;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if ([responseObject[@"issuccess"] isEqualToString:@"true"]) {
//            return YES;
        } else {
//            return NO;
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
    }];
    return issuccess;
}

@end
