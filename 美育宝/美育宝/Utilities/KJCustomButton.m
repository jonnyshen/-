//
//  KJCustomButton.m
//  KuaiJieLife
//
//  Created by working on 16/3/12.
//  Copyright © 2016年 KuaiJie. All rights reserved.
//

#import "KJCustomButton.h"
#import "ColorAndPort.h"
#import "UIImageView+TRRoundimage.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation KJCustomButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        //创建左边显示城市的UIBarButtonItem
        //        self = [CustomButton buttonWithType:UIButtonTypeCustom];
        //[self setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
        //先设置按钮里面的内容居中
          self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        //设置图片居左右边 －>向左移35
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
        //设置文字居左 －>向右移30
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [imageV setRoundImageView];
        [self addSubview:imageV];
        imageV.image = [UIImage imageNamed:@"user_head.png"];
        
        
        
        
        
        
        //先给定一个默认城市
        //[self setTitle:@"北京" forState:UIControlStateNormal];
        //self.titleLabel.font = FONT_SIZE14;
    }
    
    return self;
}
@end
