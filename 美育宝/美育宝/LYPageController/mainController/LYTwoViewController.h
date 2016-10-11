//
//  LYTwoViewController.h
//  Page Demo
//
//  Created by 刘勇航 on 16/3/12.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LYMainViewController;
@interface LYTwoViewController : UIViewController

@property (nonatomic, copy) void (^classDidSelected)(NSInteger);
@property (nonatomic, weak)LYMainViewController *parentController;


@end
