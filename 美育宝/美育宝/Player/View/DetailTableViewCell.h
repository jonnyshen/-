//
//  DetailTableViewCell.h
//  Page Demo
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
-(void)setTableViewCellModel:(id)obj;
@end
