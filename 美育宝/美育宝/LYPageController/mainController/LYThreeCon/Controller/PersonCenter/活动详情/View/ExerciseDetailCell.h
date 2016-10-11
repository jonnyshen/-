//
//  ExerciseDetailCell.h
//  美育宝
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExerciseDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *placeLb;
@property (weak, nonatomic) IBOutlet UILabel *startLb;
@property (weak, nonatomic) IBOutlet UILabel *endLb;

@property (weak, nonatomic) IBOutlet UILabel *memberLb;
@property (weak, nonatomic) IBOutlet UILabel *gatherPlace;

@property (weak, nonatomic) IBOutlet UILabel *detailLb;




- (void)setTableViewCellModel:(id)obj;
@end
