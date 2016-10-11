//
//  HomeWorkCell.m
//  美育宝
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "HomeWorkCell.h"
#import "UIImage+CirleImage.h"
#import "MYToolsModel.h"
#import "UIImageView+WebCache.h"


@implementation HomeWorkCell

- (void)setHomeWOrkList:(HomeWorkModel *)homeWOrkList
{
    
    [self.headerImageView.image makeRoundedImageRadius:10.0f];
    
    self.remindButton.imageView.layer.masksToBounds = YES;
    self.remindButton.imageView.layer.cornerRadius  = 7.0f;
    
    
    if ([homeWOrkList.personImage isKindOfClass:[NSNull class]]) {
        self.headerImageView.image = [UIImage imageNamed:@"head64.png"];
    } else {
        if (homeWOrkList.personImage.length > 6) {
            [self downLoadingImage:homeWOrkList.personImage];
        }
    }
    
    if ([homeWOrkList.finishType isEqualToString:@"0"]) {
        self.doneOrNot.text = @"未完成";
        self.doneOrNot.textColor = [UIColor redColor];
    } else {
        self.doneOrNot.text = @"已完成";
        self.finishTime.hidden   = NO;
        self.remindButton.hidden = YES;
        self.finishTime.text = [self handleTimeString:homeWOrkList.finishTime];
    }
    
    self.studentName.text = homeWOrkList.studentName;
}

- (void)setHomeWorkCellModel:(HomeWorkModel *)homeWOrkList
{
    [self.headerImageView.image makeRoundedImageRadius:10.0f];
    
    self.remindButton.imageView.layer.masksToBounds = YES;
    self.remindButton.imageView.layer.cornerRadius  = 7.0f;
    
    if ([homeWOrkList.personImage isKindOfClass:[NSNull class]]) {
        self.headerImageView.image = [UIImage imageNamed:@"head64.png"];
    } else {
        if (homeWOrkList.personImage.length > 6) {
            [self downLoadingImage:homeWOrkList.personImage];
        }
    }
    
    if ([homeWOrkList.finishType isEqualToString:@"0"]) {
        self.doneOrNot.text = @"未完成";
        self.doneOrNot.textColor = [UIColor redColor];
    } else {
        self.doneOrNot.text = @"已完成";
        self.finishTime.hidden   = NO;
        self.remindButton.hidden = YES;
        self.finishTime.text = [self handleTimeString:homeWOrkList.finishTime];
    }
    
    self.studentName.text = homeWOrkList.studentName;
}

- (NSString *)handleTimeString:(NSString *)timeStr
{
    if (timeStr.length < 12) {
        return nil;
    }
    NSString *str = [timeStr substringWithRange:NSMakeRange(0, 12)];
    //NSLog(@"......%@",str);
    NSDateFormatter *detailFormatter = [[NSDateFormatter alloc] init];
    [detailFormatter setLocale:[NSLocale currentLocale]];
    [detailFormatter setDateFormat:@"yyyyMMdd HHmm"];
    NSDate *date = [detailFormatter dateFromString:str];
    return [[NSString stringWithFormat:@"%@",date] substringWithRange:NSMakeRange(0, 16)];;
}


- (void)downLoadingImage:(NSString *)pictureString
{
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *imgStr = [tools sendFileString:@"DXMessagePicture.plist" andNumber:0];
    
    NSString *cutIndexStr = [pictureString substringWithRange:NSMakeRange(0, 6)];
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",imgStr, cutIndexStr, pictureString];
//    NSLog(@"%@",imageUrl);
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
}



@end
