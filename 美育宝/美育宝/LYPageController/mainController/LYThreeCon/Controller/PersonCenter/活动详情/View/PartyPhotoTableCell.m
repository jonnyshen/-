//
//  PartyPhotoTableCell.m
//  美育宝
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "PartyPhotoTableCell.h"
#import "ImageModel.h"
#import "PreviewImageView.h"
#import "MYToolsModel.h"
#import "UIImageView+WebCache.h"

@implementation PartyPhotoTableCell
{
    NSString *_photoPath;
}


- (void)setTableViewCellModel:(ImageModel *)obj
{
    self.imageEXView.layer.masksToBounds = YES;
    self.imageEXView.layer.cornerRadius = 3.0;
    self.imageEXView.userInteractionEnabled = YES;
    
    MYToolsModel *tools = [MYToolsModel new];
    _photoPath = [tools sendFileString:@"ImageEX.plist" andNumber:0];
    
    NSString *str = [obj.imagePath substringWithRange:NSMakeRange(0, 6)];
    
    NSString *temp = [NSString stringWithFormat:@"%@%@/%@",_photoPath, str,obj.imagePath];
    [self.imageEXView sd_setImageWithURL:[NSURL URLWithString:temp] placeholderImage:[UIImage imageNamed:@"loading"]];
    CGRect frame = CGRectMake(obj.pointX, obj.pointY, obj.rectWidth, obj.rectHeight);
    [self setUpHeaderImages:frame];
}

-(void)setUpHeaderImages:(CGRect)viewFrame
{
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
    tapGR.cancelsTouchesInView = YES;
    tapGR.delaysTouchesBegan = NO;
    tapGR.delaysTouchesEnded = NO;
    tapGR.numberOfTapsRequired = 1;
    tapGR.numberOfTouchesRequired = 1;
    [tapGR addTarget:self action:@selector(handleTapView:)];
    [self.imageEXView addGestureRecognizer:tapGR];
}

- (void)handleTapView:(CGRect)gestureRecognizer
{
    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
    CGRect startRect = [self.imageEXView convertRect:self.imageEXView.bounds toView:windows];
    [PreviewImageView showPreviewImage:self.imageView.image startImageFrame:startRect inView:windows viewFrame:gestureRecognizer];
}


@end
