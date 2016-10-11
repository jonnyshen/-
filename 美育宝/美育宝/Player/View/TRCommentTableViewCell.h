//
//  TRCommentTableViewCell.h
//  Page Demo
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRCommentModel.h"

@interface TRCommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *teacherName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *commentDetail;
@property (weak, nonatomic) IBOutlet UIButton *deleCommentBtn;

@property (strong, nonatomic) TRCommentModel *obj;

-(void)setTableViewCellModel:(id)obj;

@end
