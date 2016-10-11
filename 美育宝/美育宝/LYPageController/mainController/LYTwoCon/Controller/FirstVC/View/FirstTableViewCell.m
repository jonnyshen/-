//
//  FirstTableViewCell.m
//  Page Demo
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "FirstTableViewCell.h"
#import "TRSchoolClass.h"
#import "UIImageView+WebCache.h"
#import "MYToolsModel.h"


@implementation FirstTableViewCell

- (void)setTableViewCellModel:(TRSchoolClass *)obj
{
    self.backgroundColor = [UIColor whiteColor];

    self.title.text = obj.title;
    self.subTitle.text = [NSString stringWithFormat:@"进行到第%@课时",obj.subTitle];
    self.times.hidden = YES;
    
    
    self.imgUrl.layer.cornerRadius = 8;
    self.imgUrl.layer.masksToBounds = YES;
    if ([obj.imgUrl isKindOfClass:[NSNull class]]) {
        self.imgUrl.image = [UIImage imageNamed:@"002.jpg"];
    } else {
        MYToolsModel *tools = [[MYToolsModel alloc] init];
        NSString *imageString = [tools sendFileString:@"FirstVC.plist" andNumber:0];
        NSString *pieceStr = [obj.imgUrl substringWithRange:NSMakeRange(0, 6)];
        
        [self.imgUrl sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@", imageString, pieceStr,obj.imgUrl]]];
    }
    
    
}

@end
