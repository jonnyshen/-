//
//  ZDJingXuanTopHeadView.m
//  1012GiftTips
//
//  Created by Apple on 15/10/15.
//  Copyright © 2015年 itcast. All rights reserved.
//

#import "ZDJingXuanTopHeadView.h"


#define ZDADCount 6
#define ZDBtnCount 4
#define scrollViewWidth ZDScreenSize.width

@interface ZDJingXuanTopHeadView ()

@end

@implementation ZDJingXuanTopHeadView


+ (instancetype)jingXuanTopHeadView
{
    ZDJingXuanTopHeadView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil] lastObject];
   
    return view;
}


- (void)awakeFromNib
{
    
    [super awakeFromNib];
    
    
    
//   NSLog(@"%@", self.subviews);
    
    
}




#pragma mark - 产品推荐按钮点击事件
- (IBAction)jingXuanBtnClick:(UIButton *)sender
{
    if (self.jingPinBtnClickBlock)
    {
        self.jingPinBtnClickBlock(sender.tag);
    }
}





- (void)dealloc
{
    NSLog(@"headerView释放了");
}


@end
