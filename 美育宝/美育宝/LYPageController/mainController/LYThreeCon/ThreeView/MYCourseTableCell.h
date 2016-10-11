//
//  MYCourseTableCell.h
//  Page Demo
//
//  Created by apple on 16/5/24.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYCourse.h"

@interface MYCourseTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ClassImage;
@property (weak, nonatomic) IBOutlet UILabel *course;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *teacher;
-(void)setTableViewCellModel:(id)obj;
@end
