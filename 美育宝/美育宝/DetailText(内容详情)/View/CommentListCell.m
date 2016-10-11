//
//  CommentListCell.m
//  Page Demo
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "CommentListCell.h"
#import "MYToolsModel.h"
#import "UIImageView+WebCache.h"

@implementation CommentListCell

- (void)setTableViewCellModel:(CommListModel *)obj
{
    self.headImage.layer.cornerRadius = 8;
    self.headImage.layer.masksToBounds = YES;
    if ([obj.imageUrl isKindOfClass:[NSNull class]]) {
        self.headImage.image = [UIImage imageNamed:@"sub_01.png"];
    } else {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:obj.imageUrl]];
    }
    
    self.commLB.text = obj.comment;
    if ([obj.teacherName isKindOfClass:[NSNull class]]) {
        self.teacherLB.text = @" ";
    } else {
        self.teacherLB.text = obj.teacherName;
    }
}

- (void)setObj:(CommListModel *)obj
{
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *userName  = [tools sendFileString:@"LoginData.plist" andNumber:6];
    if ([obj.teacherName isEqualToString:userName]) {
        self.deleteBtn.hidden = NO;
    } else {
        self.deleteBtn.hidden = YES;
    }
    
    self.headImage.layer.cornerRadius = 8;
    self.headImage.layer.masksToBounds = YES;
    if ([obj.imageUrl isKindOfClass:[NSNull class]]) {
        self.headImage.image = [UIImage imageNamed:@"sub_01.png"];
    } else {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:obj.imageUrl]];
    }
    
    self.commLB.text = obj.comment;
    if ([obj.teacherName isKindOfClass:[NSNull class]]) {
        self.teacherLB.text = @" ";
    } else {
        self.teacherLB.text = obj.teacherName;
    }
}

@end
