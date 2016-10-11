//
//  MYRecommandCell.h
//  Page Demo
//
//  Created by apple on 16/5/27.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recommand.h"
@interface MYRecommandCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageUrl;
@property (weak, nonatomic) IBOutlet UILabel *className;
- (void)setCollectionViewCellModel:(Recommand *)obj;
@end
