//
//  SchoolReortTableCell.m
//  Page Demo
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "SchoolReortTableCell.h"

@implementation SchoolReortTableCell

- (void)setSchoolReportTableViewModel:(ScoreModel *)obj
{
    self.AllMarksLb.text = @"1500";
    
}

- (void)setTableViewCellModel:(ScoreModel *)obj
{
    self.AllMarksLb.text = obj.allScore;
    self.GetMarksLb.text = obj.getScore;
    self.ScoreLb.text    = obj.marksChance;
    self.rewardNumber.text = [NSString stringWithFormat:@"%ld",obj.rewardNum];
}

@end
