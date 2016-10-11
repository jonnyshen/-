//
//  MYToolsModel.h
//  Page Demo
//
//  Created by apple on 16/5/20.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYToolsModel : NSObject

//保存数据到plist文件
- (void)saveDataToPlistWithPlistName:(NSString *)fileName andData:(NSArray *)data;
- (void)saveToPlistWithPlistName:(NSString *)fileName andData:(NSString *)data;
- (void)saveToPlistWithPlistName:(NSString *)fileName fileData:(NSData *)data andOrder:(NSInteger)order;
- (void)saveToPlistWithPlistName:(NSString *)fileName andDict:(NSDictionary *)data;



//从plist文件或取数据
- (NSString *)sendFileString:(NSString *)str andNumber:(NSInteger)number;

- (NSArray *)getDataArrayFromPlist:(NSString *)str;

- (NSMutableArray *)getArrayFromPlistName:(NSString *)str andNumber:(NSInteger)number;

- (NSDictionary *)getDictArrayFromPlist:(NSString *)str;
@end
