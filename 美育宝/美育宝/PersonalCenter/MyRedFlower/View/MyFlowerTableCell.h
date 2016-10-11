//
//  MyFlowerTableCell.h
//  Page Demo
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlowerModel.h"

@interface MyFlowerTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *stuName;
@property (weak, nonatomic) IBOutlet UILabel *winTime;
@property (weak, nonatomic) IBOutlet UILabel *teacher;
@property (weak, nonatomic) IBOutlet UILabel *reason;
@property (weak, nonatomic) IBOutlet UILabel *flowerNumLb;

-(void)setTableViewCellModel:(FlowerModel *)obj;

@end
