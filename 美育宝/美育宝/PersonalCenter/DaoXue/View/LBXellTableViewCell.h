//
//  LBXellTableViewCell.h
//  Page Demo
//
//  Created by apple on 16/5/5.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBCellModel.h"

@interface LBXellTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
@property (weak, nonatomic) IBOutlet UILabel *BTLabel;
@property (weak, nonatomic) IBOutlet UILabel *postLabel;


- (void)setLBTableViewCellModel:(LBCellModel *)obj;


@end
