//
//  DXMessageViewCell.m
//  美育宝
//
//  Created by apple on 16/8/17.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "DXMessageViewCell.h"
#import "MessageModel.h"
@implementation DXMessageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCellModel:(MessageModel *)obj
{
    self.titleLabel.text = obj.titleMessage;
    self.messageLabel.text = obj.messageDetail;
    
    
}


@end
