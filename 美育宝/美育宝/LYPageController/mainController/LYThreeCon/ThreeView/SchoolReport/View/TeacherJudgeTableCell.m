//
//  TeacherJudgeTableCell.m
//  Page Demo
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "TeacherJudgeTableCell.h"

@implementation TeacherJudgeTableCell

- (void)setTableViewCellModel:(MYRewardNumber *)obj
{
    self.teacher.text = obj.teacher;
    self.detail.text  = [NSString stringWithFormat:@"获得小红花🌺数：%@朵🌺", obj.redFlower];
    self.rewardLb.text = obj.rewardReason;
    
    NSString *pieceStr = [obj.rewardTime substringWithRange:NSMakeRange(0, 8)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"yyyyddmm"];
    NSDate *date = [formatter dateFromString:pieceStr];
    
    NSString *timeString = [[NSString stringWithFormat:@"%@",date] substringWithRange:NSMakeRange(0, 10)];
    
    self.times.text = timeString;
}

@end
