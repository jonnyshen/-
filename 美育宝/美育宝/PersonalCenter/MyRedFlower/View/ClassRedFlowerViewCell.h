//
//  ClassRedFlowerViewCell.h
//  美育宝
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassRedFlowerViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *goldBtn;
@property (weak, nonatomic) IBOutlet UIButton *silverBtn;
@property (weak, nonatomic) IBOutlet UIButton *bronzeBtn;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLb;
@property (weak, nonatomic) IBOutlet UILabel *secondNameLb;
@property (weak, nonatomic) IBOutlet UILabel *thirdNameLb;

-(void)setTableViewCellModel:(id)obj;


@end
