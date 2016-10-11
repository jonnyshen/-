//
//  MYSunCount.m
//  美育宝
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYSunCount.h"

@implementation MYSunCount

- (NSInteger)requestForAcountSum:(NSString *)string requestURL:(NSString *)url
{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    __block NSInteger pageSize = 10;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        pageSize = [[dict objectForKey:string] integerValue];
        
    }];
    [dataTask resume];
    return pageSize;
}


@end
