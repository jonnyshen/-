//
//  HomeWorkCell.h
//  美育宝
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeWorkModel.h"

@interface HomeWorkCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *studentName;
@property (weak, nonatomic) IBOutlet UILabel *doneOrNot;
@property (weak, nonatomic) IBOutlet UILabel *finishTime;
@property (weak, nonatomic) IBOutlet UIButton *remindButton;

@property (strong, nonatomic) HomeWorkModel *homeWOrkList;

- (void)setHomeWorkCellModel:(HomeWorkModel *)homeWOrkList;

@end
