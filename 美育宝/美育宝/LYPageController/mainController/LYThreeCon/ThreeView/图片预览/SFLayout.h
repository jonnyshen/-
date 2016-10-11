//
//  SFLayout.h
//  朋友圈图片浏览
//
//  Created by ShaoFeng on 16/4/12.
//  Copyright © 2016年 Cocav. All rights reserved.
//  blog: http://blog.csdn.net/feng2qing

#import <Foundation/Foundation.h>
#import "UIImageView+MJWebCache.h"
#import "UIImageView+WebCache.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface SFLayout : NSObject

@property (nonatomic,strong)NSMutableArray *arrayUrl;

@property (nonatomic,strong)UIView *pictureView;

/**
 *  创建一个图片数组
 */
- (void)setPictureArray;

/**
 *  调整9张图片的位置
 *
 *  @param space   图片间距
 *  @param array   要展示的图片数组
 *  @param originX 起始横坐标
 *  @param originY 起始纵坐标
 *
 *  @return 返回这些图片所占用的高度,方便后面的布局
 */
- (NSInteger)adjustPictureLocationWithSpace:(NSInteger )space pictureArray:(NSArray *)array OriginX:(CGFloat )originX originY:(CGFloat )originY;
@end
