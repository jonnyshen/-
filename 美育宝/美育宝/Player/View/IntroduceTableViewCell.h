//
//  IntroduceTableViewCell.h
//  Page Demo
//
//  Created by apple on 16/5/12.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroduceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *className;
@property (weak, nonatomic) IBOutlet UILabel *classNameDetail;
@property (weak, nonatomic) IBOutlet UILabel *authorDetail;

-(void)setTableViewCellModel:(id)obj;


@end
