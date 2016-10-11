//
//  UIImageView+TRRoundimage.m
//  SlideNav
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 赵贺. All rights reserved.
//

#import "UIImageView+TRRoundimage.h"

@implementation UIImageView (TRRoundimage)

- (void)setRoundImageView
{
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.borderWidth = 1;
    [self.layer setCornerRadius:CGRectGetWidth([self bounds]) / 2];
}

@end
