//
//  FirstVCNewsModel.h
//  美育宝
//
//  Created by apple on 16/8/19.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FirstVCNewsModel : NSObject


@property (nonatomic , strong)NSString *title;
@property (nonatomic , strong)NSString *detailHtml;

@property (nonatomic, strong) NSString *newsID;
@property (nonatomic , strong)NSString *imagePath;
- (instancetype)initWithNewsDict:(NSDictionary *)dict;
+ (instancetype)newsDataWithDict:(NSDictionary *)dictor;

@end
