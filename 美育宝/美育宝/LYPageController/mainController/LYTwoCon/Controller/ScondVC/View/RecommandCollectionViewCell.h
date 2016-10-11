//
//  RecommandCollectionViewCell.h
//  Page Demo
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommandCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgUrl;
@property (weak, nonatomic) IBOutlet UILabel *title;

-(void)setCellModel:(id)obj;

@end
