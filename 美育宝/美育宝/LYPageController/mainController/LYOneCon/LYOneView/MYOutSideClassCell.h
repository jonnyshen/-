//
//  MYOutSideClassCell.h
//  美育宝
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYOutSide.h"

@interface MYOutSideClassCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *OutImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
-(void)setOutSideCellModel:(MYOutSide *)obj;
-(void)setCellModel:(id)obj;
@end
