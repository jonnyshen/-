//
//  ZDJingXuanTopHeadView.h
//  1012GiftTips
//
//  Created by Apple on 15/10/15.
//  Copyright © 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZDJingXuanTopHeadView : UIView

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *studentViewOne;
@property (weak, nonatomic) IBOutlet UIView *studentViewTwo;
@property (weak, nonatomic) IBOutlet UIView *teacherView;

@property (nonatomic, copy) void (^jingPinBtnClickBlock)(NSInteger);


+ (instancetype)jingXuanTopHeadView;

@end
