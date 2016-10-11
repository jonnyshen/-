//
//  GroupChartTableCell.m
//  Page Demo
//
//  Created by apple on 16/6/16.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "GroupChartTableCell.h"

//static int i = 4;

@implementation GroupChartTableCell

- (void)setTableViewCellModel:(GroupChartModel *)obj
{

    self.flower.text = [NSString stringWithFormat:@"共%@朵",obj.flowerNum];
    self.name.text = obj.name;
    self.number.text = obj.rank;
    
    
//    self.number.text = [NSString stringWithFormat:@"%d",i];
//    i++;
}

@end
