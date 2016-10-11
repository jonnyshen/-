//
//  DetailTableViewCell.m
//  Page Demo
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "IntroDetail.h"

@implementation DetailTableViewCell


- (void)setTableViewCellModel:(IntroDetail *)obj
{
    self.detailLabel.text = obj.detailLb;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
