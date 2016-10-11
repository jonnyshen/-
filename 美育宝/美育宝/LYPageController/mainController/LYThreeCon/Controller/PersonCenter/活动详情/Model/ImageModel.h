//
//  ImageModel.h
//  美育宝
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageModel : NSObject

@property (nonatomic, strong) NSString *imagePath;
//@property (nonatomic,assign) Rect frame;
@property (nonatomic,assign) float pointX;
@property (nonatomic,assign) float pointY;
@property (nonatomic,assign) float rectWidth;
@property (nonatomic,assign) float rectHeight;
//@property (nonatomic,assign) float poiRect;
@end
