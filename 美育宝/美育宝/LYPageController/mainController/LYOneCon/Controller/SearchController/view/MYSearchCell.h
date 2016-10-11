//
//  MYSearchCell.h
//  美育宝
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModel.h"

@interface MYSearchCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *classImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (nonatomic, strong) SearchModel *searchCell;
@end
