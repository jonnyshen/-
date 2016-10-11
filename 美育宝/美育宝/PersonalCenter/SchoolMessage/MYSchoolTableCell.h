//
//  MYSchoolTableCell.h
//  Page Demo
//
//  Created by apple on 16/5/27.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSchool.h"
#import "ExerciseModel.h"

@interface MYSchoolTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *campImage;
@property (weak, nonatomic) IBOutlet UILabel *campName;
@property (weak, nonatomic) IBOutlet UILabel *teacher;

@property (weak, nonatomic) IBOutlet UILabel *times;
@property (weak, nonatomic) IBOutlet UILabel *detail;

@property (strong, nonatomic) MYSchool *schoolList;

- (void)setTableViewCellModel:(ExerciseModel *)obj;

@end
