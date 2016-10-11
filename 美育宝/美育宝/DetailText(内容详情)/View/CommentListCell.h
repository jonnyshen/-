//
//  CommentListCell.h
//  Page Demo
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommListModel.h"

@interface CommentListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *commLB;

@property (weak, nonatomic) IBOutlet UILabel *teacherLB;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property(nonatomic, strong) CommListModel *obj;

-(void)setTableViewCellModel:(id)obj;

@end
