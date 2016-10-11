//
//  MoreTableCell.h
//  Page Demo
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReconmmandModal.h"
#import "HotClassModal.h"

@interface MoreTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *classNum;

- (void)setTableViewCellModel:(HotClassModal *)obj;



- (void)setRecommendTableCell:(ReconmmandModal *)recomm;
@end
