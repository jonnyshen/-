//
//  UIImage+CirleImage.m
//  美育宝
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "UIImage+CirleImage.h"

@implementation UIImage (CirleImage)

-(UIImage *)makeRoundedImageRadius:(float)radius
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, self.size.width, self.size.height);
    imageLayer.contents = (id) self.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
    
    UIGraphicsBeginImageContext(self.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return roundedImage;
}


@end
