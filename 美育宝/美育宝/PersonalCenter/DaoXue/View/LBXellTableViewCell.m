//
//  LBXellTableViewCell.m
//  Page Demo
//
//  Created by apple on 16/5/5.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "LBXellTableViewCell.h"



@interface LBXellTableViewCell()

@end

@implementation LBXellTableViewCell

- (void)setLBTableViewCellModel:(LBCellModel *)obj
{
    //btn++;
    
   // NSString *btnTitle = [NSString stringWithFormat:@"%d",btn];
    //[self.orderBtn setTitle:btnTitle forState:UIControlStateNormal];
    
    self.BTLabel.text = obj.titleBT;
    if ([obj.isPost isEqualToString:@"1"]) {
        self.postLabel.text = @"已推送";
        self.postLabel.textColor = [UIColor greenColor];
    } else {
        self.postLabel.text = @"未推送";
        self.postLabel.textColor = [UIColor redColor];
    }
}

@end
