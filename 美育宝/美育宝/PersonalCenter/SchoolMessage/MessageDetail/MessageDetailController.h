//
//  MessageDetailController.h
//  美育宝
//
//  Created by apple on 16/8/6.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailController : UIViewController

- (instancetype)initWithTitle:(NSString *)title userName:(NSString *)userName imageUrl:(NSString *)imageUrl noticsDetail:(NSString *)detail schoolOrOutside:(NSString *)school noticTimes:(NSString *)times;

- (instancetype)initWithNewsID:(NSString *)newsID;

@end
