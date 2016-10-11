//
//  MYExerciseTableCell.m
//  Page Demo
//
//  Created by apple on 16/5/23.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYExerciseTableCell.h"
#import "UIImageView+WebCache.h"
#import "ExerciseModel.h"
#import "MYToolsModel.h"

@implementation MYExerciseTableCell

- (void)setTableViewCellModel:(ExerciseModel *)obj
{
    self.imageUrl.layer.cornerRadius = 8;
    self.imageUrl.layer.masksToBounds = YES;
    
    MYToolsModel *tools = [[MYToolsModel alloc] init];
    NSString *image = [tools sendFileString:@"image.plist" andNumber:0];
    
    NSString *str = [obj.imageStr substringWithRange:NSMakeRange(0, 6)];
    NSString *temp = [NSString stringWithFormat:@"%@%@/%@",image,str,obj.imageStr];
   // NSLog(@"------temp----%@",temp);
    
    [self.imageUrl sd_setImageWithURL:[NSURL URLWithString:temp]];
    
    self.partyName.text = obj.partyName;
    
//    
//    NSString *str = [obj.partyTime substringWithRange:NSMakeRange(6, 6)];
//    NSDateFormatter *detailFormatter = [[NSDateFormatter alloc] init];
//    [detailFormatter setLocale:[NSLocale currentLocale]];
//    [detailFormatter setDateFormat:@"yyyyMMdd"];
//    NSDate *date = [detailFormatter dateFromString:str];
//    self.partyTime.text = [NSString stringWithFormat:@"%@",date];
    self.partyTime.text = obj.partyTime;
    
    
    
}

@end
