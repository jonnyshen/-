//
//  PreviewPhotoView.h
//
//
//  Created by Joywii on 13-10-16.
//  Copyright (c) 2016年 jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewImageView : UIView
/**
 点击image view图片放大到整个屏幕
 */


+ (void)showPreviewImage:(UIImage *)image startImageFrame:(CGRect)startImageFrame inView:(UIView *)inView viewFrame:(CGRect)viewFrame;

@end
