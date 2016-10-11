//
//  JudgeDetailTableCell.h
//  Page Demo
//
//  Created by apple on 16/6/23.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JudgeDetailTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *judgementLb;
@property (weak, nonatomic) IBOutlet UILabel *teacher;
-(void)setTableViewCellModel:(id)obj;
@end
