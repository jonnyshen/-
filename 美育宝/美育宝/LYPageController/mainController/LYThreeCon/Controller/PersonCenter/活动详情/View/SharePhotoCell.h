//
//  SharePhotoCell.h
//  美育宝
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFLayout.h"
#import "ActivityImageModel.h"


@interface SharePhotoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (nonatomic,strong)SFLayout* layout;

@property (nonatomic, strong) ActivityImageModel *active;

-(void)setTableViewCellModel:(ActivityImageModel *)obj;
@end
