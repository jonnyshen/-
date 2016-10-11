//
//  MYCollectTableCell.h
//  Page Demo
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYCollect.h"

@interface MYCollectTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *collectImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *teacher;

-(void)setTableCellModel:(id)obj;


@end
