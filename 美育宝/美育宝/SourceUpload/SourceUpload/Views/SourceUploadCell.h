//
//  SourceUploadCell.h
//  美育宝
//
//  Created by iOS程序员 on 2016/10/9.
//  Copyright © 2016年 JiaYong Shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SourceData.h"

@interface SourceUploadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *workImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIImageView *imgType;


@property (nonatomic, strong) SourceData *worksData;
@end
