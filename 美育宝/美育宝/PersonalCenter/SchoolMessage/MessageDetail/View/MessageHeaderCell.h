//
//  MessageHeaderCell.h
//  美育宝
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticDetailModel.h"

@interface MessageHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *masterLabel;
@property (weak, nonatomic) IBOutlet UIImageView *noticImageView;
@property (weak, nonatomic) IBOutlet UILabel *noticDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *noticTimeLabel;

@property (nonatomic, strong) NoticDetailModel *noticList;


@end
