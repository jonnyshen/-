//
//  MYShowWorksCollectionCell.h
//  美育宝
//
//  Created by apple on 16/8/6.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYWorkImage.h"

@interface MYShowWorksCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) MYWorkImage *obj;

- (void)setCellModel:(id)obj;
@end
