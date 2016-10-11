//
//  MYPlayerNotesTableCell.h
//  Page Demo
//
//  Created by apple on 16/5/27.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYPlayerNotesTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *notes;
@property (weak, nonatomic) IBOutlet UILabel *times;
-(void)setTableViewCellModel:(id)obj;
@end
