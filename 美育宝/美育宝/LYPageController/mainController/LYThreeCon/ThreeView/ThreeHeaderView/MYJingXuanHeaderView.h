//
//  MYJingXuanHeaderView.h
//  美育宝
//
//  Created by apple on 16/7/28.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYJingXuanHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *StuLoginBtn;

@property (nonatomic, copy) void (^StudentJingXuanHeaderView)(NSInteger);


+ (instancetype)StudentJingXuanHeaderView;

@end
