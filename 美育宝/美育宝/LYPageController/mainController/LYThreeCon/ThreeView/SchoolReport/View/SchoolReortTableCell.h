//
//  SchoolReortTableCell.h
//  Page Demo
//
//  Created by apple on 16/6/22.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreModel.h"

@interface SchoolReortTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *AllMarksLb;
@property (weak, nonatomic) IBOutlet UILabel *GetMarksLb;
@property (weak, nonatomic) IBOutlet UILabel *ScoreLb;
@property (weak, nonatomic) IBOutlet UILabel *rewardNumber;

- (void)setSchoolReportTableViewModel:(ScoreModel *)obj;

-(void)setTableViewCellModel:(id)obj;

@end
