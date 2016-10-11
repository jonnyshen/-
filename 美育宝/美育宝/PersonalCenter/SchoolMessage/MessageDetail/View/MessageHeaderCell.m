//
//  MessageHeaderCell.m
//  美育宝
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MessageHeaderCell.h"
#import "UIImageView+WebCache.h"

@implementation MessageHeaderCell

- (void)setNoticList:(NoticDetailModel *)noticList
{
    self.titleLabel.text = noticList.campTitle;
//    self.masterLabel.text = noticList.teacher;
    self.noticDetailLabel.text = noticList.detail;
//    self.schoolLabel.text = noticList.school;
    
    [self.noticImageView sd_setImageWithURL:[NSURL URLWithString:noticList.imageStr] placeholderImage:[UIImage imageNamed:@"loading"]];
    
    
    if (noticList.times.length < 8) {
        self.noticTimeLabel.text = nil;
    } else {
        NSString *pieceString = [noticList.times substringWithRange:NSMakeRange(0, 8)];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        NSDate *date = [dateFormatter dateFromString:pieceString];
        NSString *dateString = [[NSString stringWithFormat:@"%@",date] substringWithRange:NSMakeRange(0, 10)];
        self.noticTimeLabel.text = dateString;
    }
    
    
    
}




@end
