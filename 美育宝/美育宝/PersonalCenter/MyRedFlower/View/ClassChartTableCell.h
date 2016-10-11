//
//  ClassChartTableCell.h
//  Page Demo
//
//  Created by apple on 16/6/14.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassChartModel.h"

@interface ClassChartTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *chart;
@property (weak, nonatomic) IBOutlet UILabel *className;
@property (weak, nonatomic) IBOutlet UILabel *stuName;
@property (weak, nonatomic) IBOutlet UILabel *flowerNumber;

@property (nonatomic, strong) ClassChartModel *chartList;

-(void)setTableViewCellModel:(id)obj;

@end
