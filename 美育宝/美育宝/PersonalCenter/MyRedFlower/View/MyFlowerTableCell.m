//
//  MyFlowerTableCell.m
//  Page Demo
//
//  Created by apple on 16/6/15.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MyFlowerTableCell.h"

@implementation MyFlowerTableCell

- (void)setTableViewCellModel:(FlowerModel *)obj
{
    self.stuName.text = obj.name;
    
    NSString *str = [obj.winTime substringWithRange:NSMakeRange(0, 8)];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    [formatter setLocale:[NSLocale currentLocale]];
    NSDate *date = [formatter dateFromString:str];
    self.winTime.text = [[NSString stringWithFormat:@"得奖时间：%@",date] substringWithRange:NSMakeRange(0, 15)];
    
    self.teacher.text = [NSString stringWithFormat:@"指导老师：%@", obj.teacher];
    self.reason.text  = [NSString stringWithFormat:@"得奖理由：%@", obj.reason];
    
    self.flowerNumLb.text = [NSString stringWithFormat:@"获得%@朵小红花",obj.flowerNumber];
}

@end
