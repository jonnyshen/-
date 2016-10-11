//
//  CaculateCell.m
//  美育宝
//
//  Created by apple on 16/8/17.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "CaculateCell.h"



@implementation CaculateCell



- (void)setCellModel:(LBCellModel *)cellModel
{
    
    self.detailLabel.text = cellModel.titleBT;
    
        self.ispostLabel.text = @"已推送";
        self.ispostLabel.textColor = [UIColor greenColor];
   
    
    
}


@end
