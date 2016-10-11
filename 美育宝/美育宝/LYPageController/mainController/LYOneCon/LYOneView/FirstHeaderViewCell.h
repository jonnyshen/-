//
//  FirstHeaderViewCell.h
//  美育宝
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstHeaderViewCell : UICollectionViewCell
@property (nonatomic , copy) void (^TapHeaderActionBlock)(NSString* pageIndexUrl);
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


-(void)setCellModel:(NSArray *)obj;
@end
