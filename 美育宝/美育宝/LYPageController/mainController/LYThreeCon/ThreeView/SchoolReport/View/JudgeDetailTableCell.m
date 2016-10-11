//
//  JudgeDetailTableCell.m
//  Page Demo
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "JudgeDetailTableCell.h"
#import "MYJudge.h"
@implementation JudgeDetailTableCell

- (void)setTableViewCellModel:(MYJudge *)obj
{
    self.judgementLb.text = obj.judge;
}

@end
