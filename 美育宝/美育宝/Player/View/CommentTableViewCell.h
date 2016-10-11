//
//  CommentTableViewCell.h
//  Page Demo
//
//  Created by apple on 16/5/13.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
{
    CGFloat commentRank;
    NSString *_classID;
    NSString *_userCode;
    NSString *_PassWord;
}
@property (weak, nonatomic) IBOutlet UILabel *wellReviewLB;
@property (weak, nonatomic) IBOutlet UILabel *middleReviewLB;
@property (weak, nonatomic) IBOutlet UILabel *badReviewLB;
@property (weak, nonatomic) IBOutlet UILabel *abilityLB;
@property (weak, nonatomic) IBOutlet UILabel *humorousLB;
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UITextField *commentText;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

-(void)setTableViewCellModel:(id)obj;

@end
