//
//  MarksDetailTableCell.m
//  Page Demo
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MarksDetailTableCell.h"

@implementation MarksDetailTableCell

- (void)setTableViewCellModel:(MYSubjectScore *)obj
{
    self.subjectLb.text = obj.subjectName;
    self.getMarks.text  = obj.getScore;
    self.allMarks.text  = obj.fullScore;
    self.teacherLb.text = obj.teacher;
    self.rank.text      = obj.rank;
    
}

@end
