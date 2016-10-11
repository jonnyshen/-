//
//  TeacherJudgeTableCell.h
//  Page Demo
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYRewardNumber.h"

@interface TeacherJudgeTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *teacher;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UILabel *times;
@property (weak, nonatomic) IBOutlet UILabel *rewardLb;



-(void)setTableViewCellModel:(id)obj;
@end
