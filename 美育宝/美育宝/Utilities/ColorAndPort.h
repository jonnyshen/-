//
//  ColorAndPort.h
//  KuaiJieLife
//
//  Created by KuaiJie on 16/3/11.
//  Copyright © 2016年 KuaiJie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorAndPort : NSObject

// 颜色赋值
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define KJUIColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//各种字体大小
#define FONT_SIZE16  [UIFont systemFontOfSize:16.0f]
#define FONT_SIZE12  [UIFont systemFontOfSize:12.0f]
#define FONT_SIZE14  [UIFont systemFontOfSize:14.0f]


#define TAB_ITEM_SELECTED_COLOR RGB(46, 171, 157)
// ***
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
////home视图button的宽度和高度
#define home_BtnW kScreenWidth/4
#define home_BtnH      home_BtnW
#define two_home_BtnH  home_BtnH * 2

@end
