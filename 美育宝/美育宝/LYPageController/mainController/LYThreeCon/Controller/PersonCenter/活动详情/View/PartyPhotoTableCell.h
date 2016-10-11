//
//  PartyPhotoTableCell.h
//  美育宝
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartyPhotoTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageEXView;

-(void)setTableViewCellModel:(id)obj;


@end
