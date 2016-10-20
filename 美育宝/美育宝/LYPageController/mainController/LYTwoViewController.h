//
//  LYTwoViewController.h
//  Page Demo
//
//  Created by 沈嘉勇 on 16/4/12.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LYMainViewController;
@interface LYTwoViewController : UIViewController

@property (nonatomic, copy) void (^classDidSelected)(NSInteger);
@property (nonatomic, weak)LYMainViewController *parentController;


@end
