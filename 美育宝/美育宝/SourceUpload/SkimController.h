//
//  SkimController.h
//  美育宝
//
//  Created by iOS程序员 on 2016/10/9.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 点击资源和作品，跳转浏览的控制器
 */

@interface SkimController : UIViewController

- (instancetype)initWithHeaderPicture:(NSString *)imageStr title:(NSString *)title identifier:(NSString *)identy;

@end
