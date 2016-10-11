//
//  MYSearchDetailController.h
//  美育宝
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYSearchDetailController : UIViewController



@property (nonatomic, copy) NSString *requestType;
@property (nonatomic, assign, readonly) BOOL isSearch;

- (instancetype)initWithRequestSearch:(BOOL)isSearch;




@end
