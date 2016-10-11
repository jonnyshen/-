//
//  WritingCollectionViewCell.h
//  Page Demo
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WritingModal.h"

@interface WritingCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgUrl;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *classes;
@property (weak, nonatomic) IBOutlet UILabel *people;

- (void)setCellModel:(WritingModal *)obj;

@end
