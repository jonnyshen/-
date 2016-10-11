//
//  MYCollectionViewCell.h
//  Page Demo
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYCellModal.h"
@interface MYCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgUrl;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@property (weak, nonatomic) IBOutlet UILabel *free;

- (void)setCellModel:(MYCellModal *)obj;

@end
