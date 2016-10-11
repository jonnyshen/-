//
//  GroupChartTableCell.h
//  Page Demo
//
//  Created by apple on 16/6/16.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupChartModel.h"

@interface GroupChartTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *flower;
//@property (weak, nonatomic) IBOutlet UIImageView *imageIco;

-(void)setTableViewCellModel:(GroupChartModel *)obj;

@end
