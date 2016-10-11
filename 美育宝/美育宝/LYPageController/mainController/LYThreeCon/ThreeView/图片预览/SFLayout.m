//
//  SFLayout.m
//  朋友圈图片浏览
//
//  Created by ShaoFeng on 16/4/12.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import "SFLayout.h"

@interface SFLayout ()
@property (nonatomic,strong)NSMutableArray *arrayContainer;
@end

@implementation SFLayout

- (void)setPictureArray
{
    _arrayContainer= [NSMutableArray array];
    for (NSInteger i = 0; i < 9; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPicture:)];
        [imageView addGestureRecognizer:tap];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_arrayContainer addObject:imageView];
    }
}

- (void)clickPicture:(UIGestureRecognizer *)recognizer
{
    [self pictureShowWithRequestPictureArray:_arrayUrl andContaineArray:_arrayContainer currentPhotoIndex:recognizer.view.tag - 100];
}

- (void)pictureShowWithRequestPictureArray:(NSArray *)pictureArray andContaineArray:(NSArray *)array currentPhotoIndex:(NSInteger )index
{
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:pictureArray.count];
    for (int i = 0; i<pictureArray.count; i++) {
        NSString *url = _arrayUrl[i];
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url];
        photo.srcImageView = array[i];
        [photos addObject:photo];
    }
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index;
    browser.photos = photos;
    [browser show];
}

- (NSInteger)adjustPictureLocationWithSpace:(NSInteger )space pictureArray:(NSArray *)array OriginX:(CGFloat )originX originY:(CGFloat )originY
{
    CGFloat SCR_W = self.pictureView.frame.size.width;
    NSInteger arrayCount = array.count;
    CGFloat imageViewX = 0.0;
    CGFloat imageViewY = 0.0;
    if (arrayCount >= 9) {
        arrayCount = 9;
    }
    UIImageView* imageView;
    for (NSInteger i = 0; i < array.count; i ++) {
        imageView = [_arrayContainer objectAtIndex:i];
        imageView.tag = 100 + i;
        
        //if (arrayCount != 4) {
            imageViewX = i % 3;
            imageViewY = i / 3;
       // }
        
//        if (arrayCount == 4) {
//            imageViewX = i % 2;
//            imageViewY = i / 2;
//        }
//        if (arrayCount == 1) {
//            
//            [imageView sd_setImageWithURL:[NSURL URLWithString:array[i]]  placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                [imageView setFrame:CGRectMake(originX + imageViewX * (SCR_W - originX) / 1, originY + imageViewY * (SCR_W - originX) / 1, image.size.width,image.size.height)];
//            }];
//            }
            //else if (arrayCount == 4){
//            [imageView setImageURLStr:array[i] placeholder:[UIImage imageNamed:@"save_icon_highlighted"]];
//            [imageView setFrame:CGRectMake(originX + imageViewX * (SCR_W - originX) / 2, originY + imageViewY * (SCR_W - originX) / 2, (SCR_W - originX) / 2 - space, (SCR_W - originX) / 2 - space)];
       // }
        //else {
            [imageView setImageURLStr:array[i] placeholder:[UIImage imageNamed:@"save_icon_highlighted"]];
            [imageView setFrame:CGRectMake(originX + imageViewX * (SCR_W - originX) / 3, originY + imageViewY * (SCR_W - originX) / 3, (SCR_W - originX) / 3 - space, (SCR_W - originX) / 3 - space)];
       // }
        [self.pictureView addSubview:imageView];
    }
    return (CGRectGetMaxY(imageView.frame));
}

@end
