//
//  TRCommentTableViewCell.m
//  Page Demo
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "TRCommentTableViewCell.h"
#import "UIImageView+WebCache.h"

#import "HUStarView.h"
#import "MYToolsModel.h"

@implementation TRCommentTableViewCell

- (void)setObj:(TRCommentModel *)obj
{
    if (!obj.teacherName || [obj.teacherName isKindOfClass:[NSNull class]]) {
        self.teacherName.text = @"";
        self.deleCommentBtn.hidden = YES;
    } else {
        self.teacherName.text = obj.teacherName;
        
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        NSString *userName  = [tools sendFileString:@"LoginData.plist" andNumber:6];
        if ([obj.teacherName isEqualToString:userName]) {
            self.deleCommentBtn.hidden = NO;
        } else {
            self.deleCommentBtn.hidden = YES;
        }
    }
    
   
    
    
    self.commentDetail.text = obj.detailComment;
    
    self.headerImage.layer.cornerRadius = 8;
    self.headerImage.layer.masksToBounds = YES;
    if (!obj.imageUrl || [obj.imageUrl isKindOfClass:[NSNull class]]) {
        obj.imageUrl = @"http://d.hiphotos.baidu.com/image/pic/item/f31fbe096b63f6243847fe078544ebf81a4ca398.jpg";
    }
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:obj.imageUrl]];
    
    NSString *str = [obj.time substringWithRange:NSMakeRange(0, 12)];
    NSDateFormatter *detailFormatter = [[NSDateFormatter alloc] init];
    [detailFormatter setLocale:[NSLocale currentLocale]];
    [detailFormatter setDateFormat:@"yyyyMMddHHmm"];
    NSDate *date = [detailFormatter dateFromString:str];
    //    NSLog(@"%@----date---%@",str,date);
    self.time.text = [[NSString stringWithFormat:@"%@",date] substringWithRange:NSMakeRange(0, 16)];
    
    
    CGFloat numberOfStar = [obj.rank floatValue];;
    //numberOfStar =
    HUStarView *starRateView = [[HUStarView alloc] initWithFrame:CGRectMake(0, 0, self.starView.frame.size.width, self.starView.frame.size.height) numberOfStars:5 stars:numberOfStar];
    
    
    //starRateView4.userInteractionEnabled = NO;
    [self.starView addSubview:starRateView];
    self.starView.userInteractionEnabled = NO;

}

-(void)setTableViewCellModel:(TRCommentModel *)obj{
    
    if (!obj.teacherName || [obj.teacherName isKindOfClass:[NSNull class]]) {
        self.teacherName.text = @"";
    } else {
        self.teacherName.text = obj.teacherName;
    }
    
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *userName  = [tools sendFileString:@"LoginData.plist" andNumber:6];
    if ([obj.teacherName isEqualToString:userName]) {
        self.deleCommentBtn.hidden = NO;
    } else {
        self.deleCommentBtn.hidden = YES;
    }
    
    
    self.commentDetail.text = obj.detailComment;
    
    self.headerImage.layer.cornerRadius = 8;
    self.headerImage.layer.masksToBounds = YES;
    if (!obj.imageUrl || [obj.imageUrl isKindOfClass:[NSNull class]]) {
        obj.imageUrl = @"http://d.hiphotos.baidu.com/image/pic/item/f31fbe096b63f6243847fe078544ebf81a4ca398.jpg";
    }
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:obj.imageUrl]];
    
    NSString *str = [obj.time substringWithRange:NSMakeRange(0, 12)];
    NSDateFormatter *detailFormatter = [[NSDateFormatter alloc] init];
    [detailFormatter setLocale:[NSLocale currentLocale]];
    [detailFormatter setDateFormat:@"yyyyMMddHHmm"];
    NSDate *date = [detailFormatter dateFromString:str];
//    NSLog(@"%@----date---%@",str,date);
    self.time.text = [[NSString stringWithFormat:@"%@",date] substringWithRange:NSMakeRange(0, 16)];
    
    
    CGFloat numberOfStar = [obj.rank floatValue];;
    //numberOfStar =
    HUStarView *starRateView = [[HUStarView alloc] initWithFrame:CGRectMake(0, 0, self.starView.frame.size.width, self.starView.frame.size.height) numberOfStars:5 stars:numberOfStar];
    
    
    //starRateView4.userInteractionEnabled = NO;
    [self.starView addSubview:starRateView];
    self.starView.userInteractionEnabled = NO;
}

@end
