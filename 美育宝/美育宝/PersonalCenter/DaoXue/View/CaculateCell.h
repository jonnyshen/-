//
//  CaculateCell.h
//  美育宝
//
//  Created by apple on 16/8/17.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBCellModel.h"

@interface CaculateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *ispostLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;

@property (nonatomic,strong) LBCellModel *cellModel;

@end
