//
//  IntroduceTableViewCell.m
//  Page Demo
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "IntroduceTableViewCell.h"
#import "introduceModel.h"
#import "UIImageView+WebCache.h"

@implementation IntroduceTableViewCell

- (void)setTableViewCellModel:(introduceModel *)obj
{
    self.headImage.layer.cornerRadius = 10;
    self.headImage.layer.masksToBounds = YES;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:obj.imageUrl]];
    
    self.className.text = obj.className;
    self.classNameDetail.text = obj.classNickName;
    self.authorDetail.text = obj.author;
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
