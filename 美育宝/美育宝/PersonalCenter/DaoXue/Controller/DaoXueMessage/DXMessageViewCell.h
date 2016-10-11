//
//  DXMessageViewCell.h
//  美育宝
//
//  Created by apple on 16/8/17.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXMessageViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;


- (void)setCellModel:(id)obj;
@end
