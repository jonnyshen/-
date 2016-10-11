//
//  MYSearchCell.m
//  美育宝
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYSearchCell.h"
#import "MYToolsModel.h"
#import "UIImageView+WebCache.h"
#import "UIImage+CirleImage.h"

@implementation MYSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSearchCell:(SearchModel *)searchCell
{
    MYToolsModel *tools  = [[MYToolsModel alloc] init];
    NSString *image_Path = [tools sendFileString:@"SearchImagePath.plist" andNumber:0];
    NSString *file_Path = [tools sendFileString:@"SearchImagePath.plist" andNumber:1];
    
    if ([searchCell.title isKindOfClass:[NSNull class]]) {
            self.titleLabel.text = @"";
    } else {
        self.titleLabel.text = searchCell.title;
    }
    
    self.detailLabel.text = searchCell.source;
    
    NSString *timeString = [searchCell.timeStr substringWithRange:NSMakeRange(0, 8)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    [formatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [formatter dateFromString:timeString];
    
    NSString *likeTitle = [[NSString stringWithFormat:@"%@",date] substringWithRange:NSMakeRange(0, 10)];
    
    [self.likeButton setTitle:likeTitle forState:UIControlStateNormal];
    
    NSString *imageString = [searchCell.imageStr substringWithRange:NSMakeRange(0, 6)];
    NSString *imageUrl = nil;
    if ([searchCell.source isEqualToString:@"资源信息"]) {
        imageUrl = [NSString stringWithFormat:@"%@%@/%@",file_Path,imageString,searchCell.imageStr];
    } else {
        imageUrl = [NSString stringWithFormat:@"%@%@/%@",image_Path,imageString,searchCell.imageStr];
    }
    
    [self.classImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
    [self.classImage.image makeRoundedImageRadius:8.0];
}



@end
