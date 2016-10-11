//
//  ClassChartTableCell.m
//  Page Demo
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "ClassChartTableCell.h"


@implementation ClassChartTableCell

- (void)setTableViewCellModel:(ClassChartModel *)obj
{
    self.className.text = obj.className;
    self.stuName.text = obj.stuName;
    if ([obj.flowerNumber isKindOfClass:[NSNull class]]) {
        obj.flowerNumber = @"0";
        self.flowerNumber.text     = [NSString stringWithFormat:@"共%@朵",obj.flowerNumber];
    } else {
        self.flowerNumber.text     = [NSString stringWithFormat:@"共%@朵",obj.flowerNumber];
    }
    
//    a++;
    self.chart.text = [NSString stringWithFormat:@"%@",obj.rank];
    
}

- (void)setChartList:(ClassChartModel *)chartList
{
    self.chart.text = chartList.rank;
    self.className.text = chartList.className;
    self.stuName.text = chartList.stuName;
    if ([chartList.flowerNumber isKindOfClass:[NSNull class]]) {
        chartList.flowerNumber = @"0";
        self.flowerNumber.text     = [NSString stringWithFormat:@"共%@朵",chartList.flowerNumber];
    } else {
        self.flowerNumber.text     = [NSString stringWithFormat:@"共%@朵",chartList.flowerNumber];
    }
}

@end
