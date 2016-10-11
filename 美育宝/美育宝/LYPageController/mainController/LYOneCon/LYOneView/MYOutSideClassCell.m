//
//  MYOutSideClassCell.m
//  美育宝
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYOutSideClassCell.h"

#import "UIImageView+WebCache.h"

#import "GGMovieModel.h"

@implementation MYOutSideClassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setOutSideCellModel:(MYOutSide *)obj
{
    self.title.text = obj.title;
    
    self.OutImage.layer.cornerRadius = 8;
    self.OutImage.layer.masksToBounds = YES;
    
    [self.OutImage sd_setImageWithURL:[NSURL URLWithString:obj.imgUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
}

-(void)setCellModel:(GGMovieModel *)obj
{
    self.title.text = obj.title;
    
    self.OutImage.layer.cornerRadius = 8;
    self.OutImage.layer.masksToBounds = YES;
    
    [self.OutImage sd_setImageWithURL:[NSURL URLWithString:obj.imgUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
}

@end
