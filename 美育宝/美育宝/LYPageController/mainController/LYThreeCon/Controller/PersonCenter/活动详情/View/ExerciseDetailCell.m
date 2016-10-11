//
//  ExerciseDetailCell.m
//  美育宝
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "ExerciseDetailCell.h"
#import "CampDetailModel.h"

@implementation ExerciseDetailCell

- (void)setTableViewCellModel:(CampDetailModel *)obj
{
    self.titleLb.text =  obj.campName;
    self.placeLb.text = [NSString stringWithFormat:@"活动地点：%@",obj.campPlace];
    self.startLb.text = [NSString stringWithFormat:@"活动开始时间：%@",obj.startTime];
    self.endLb.text   = [NSString stringWithFormat:@"活动结束时间：%@",obj.endTime];
    self.memberLb.text = [NSString stringWithFormat:@"活动参与人：%@",obj.member];
    self.gatherPlace.text = [NSString stringWithFormat:@"集合地点：%@",obj.gatherPlace];
    self.detailLb.text = [NSString stringWithFormat:@"活动详情：%@",obj.campDetail];
}


@end
