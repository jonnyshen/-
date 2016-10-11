//
//  MYAnwserTableCell.h
//  Page Demo
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYAnwserTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *answerImage;
@property (weak, nonatomic) IBOutlet UILabel *question;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *number;

-(void)setTableViewCellModel:(id)obj;

@end
