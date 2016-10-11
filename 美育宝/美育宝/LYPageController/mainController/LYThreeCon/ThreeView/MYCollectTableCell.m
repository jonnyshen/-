//
//  MYCollectTableCell.m
//  Page Demo
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYCollectTableCell.h"

#import "UIImageView+WebCache.h"
#import "MYToolsModel.h"

@implementation MYCollectTableCell

- (void)setTableCellModel:(MYCollect *)obj
{
    if (obj.teacher == NULL) {
        obj.teacher = @"陈老师";
        self.teacher.text = obj.teacher;
    }
    self.teacher.text = obj.teacher;
    self.title.text = obj.className;
    //NSLog(@"----%@%@",obj.teacher,obj.className);
    self.collectImage.layer.cornerRadius = 8;
    self.collectImage.layer.masksToBounds = YES;
    
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *imageStr = nil;
    NSString *combination = nil;
    NSString *pieceImg = nil;
    if ([obj.imageStr length] > 6) {
        pieceImg = [obj.imageStr substringWithRange:NSMakeRange(0, 6)];
    }
    
    if ([obj.imageType isEqualToString:@"2"] ||[obj.imageType isEqualToString:@"4"] ||[obj.imageType isEqualToString:@"5"]||[obj.imageType isEqualToString:@"6"]) {
        
        imageStr = [tools sendFileString:@"Collect.plist" andNumber:2];
        combination = [NSString stringWithFormat:@"%@%@/%@",imageStr, pieceImg, obj.imageStr];
        [self.collectImage sd_setImageWithURL:[NSURL URLWithString:combination]];
        
    } else {
        self.collectImage.image = [UIImage imageNamed:@"001.jpg"];
    }
    
}

@end
