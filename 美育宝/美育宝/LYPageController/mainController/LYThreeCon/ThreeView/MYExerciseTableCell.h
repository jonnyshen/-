//
//  MYExerciseTableCell.h
//  Page Demo
//
//  Created by apple on 16/5/23.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYExerciseTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageUrl;
@property (weak, nonatomic) IBOutlet UILabel *partyName;
@property (weak, nonatomic) IBOutlet UILabel *partyTime;

-(void)setTableViewCellModel:(id)obj;


@end
