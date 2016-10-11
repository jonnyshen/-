//
//  ZDJingXuanButton.m
//  1012GiftTips
//
//  Created by Apple on 15/10/15.
//  Copyright © 2015年 itcast. All rights reserved.
//

#import "ZDJingXuanButton.h"

#define padding 10

@implementation ZDJingXuanButton

+ (instancetype)buttonWithImageName:(NSString *)name andTitle:(NSString *)title
{
    ZDJingXuanButton *btn = [[ZDJingXuanButton alloc] init];
    
    [btn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    
    [btn setTitle:title forState:UIControlStateNormal];
    
    return btn;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
}


- (void)setHighlighted:(BOOL)highlighted
{
    
}


//布局子控件frame属性
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //    ZDLog(@"%@", NSStringFromCGRect(self.frame));
    
    CGFloat imageW = 50;
    CGFloat imageH = imageW;
    CGFloat imageX = (self.frame.size.width - imageW) * 0.5;
    CGFloat imageY = padding;
    
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    CGFloat titleX = 0;
    CGFloat titleY = CGRectGetMaxY(self.imageView.frame);
    CGFloat titleW = self.frame.size.width;
    CGFloat titleH = self.frame.size.height - titleY;
    
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:10];
//    self.titleLabel.textColor = [UIColor blackColor];
}


@end
