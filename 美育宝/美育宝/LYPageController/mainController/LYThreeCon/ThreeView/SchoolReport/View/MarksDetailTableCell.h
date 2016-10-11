//
//  MarksDetailTableCell.h
//  Page Demo
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSubjectScore.h"

@interface MarksDetailTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *teacherLb;
@property (weak, nonatomic) IBOutlet UILabel *subjectLb;
@property (weak, nonatomic) IBOutlet UILabel *getMarks;
@property (weak, nonatomic) IBOutlet UILabel *allMarks;
@property (weak, nonatomic) IBOutlet UILabel *rank;

-(void)setTableViewCellModel:(id)obj;
@end
