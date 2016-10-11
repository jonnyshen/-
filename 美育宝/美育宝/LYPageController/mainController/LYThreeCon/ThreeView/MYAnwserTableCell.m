//
//  MYAnwserTableCell.m
//  Page Demo
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYAnwserTableCell.h"
#import "MYAnwser.h"

@implementation MYAnwserTableCell

- (void)setTableViewCellModel:(MYAnwser *)obj
{
   // NSLog(@"======%@-%@-%@",obj.question, obj.anwserNum,obj.time);
    self.answerImage.layer.cornerRadius = 10;
    self.answerImage.layer.masksToBounds = YES;
    self.answerImage.image = [UIImage imageNamed:@"Q&A.png"];
    
    self.question.text = obj.question;
    self.number.text = [NSString stringWithFormat:@"%@条",obj.anwserNum];
    
    NSString *str = [obj.time substringWithRange:NSMakeRange(0, 12)];
    //NSLog(@"......%@",str);
    NSDateFormatter *detailFormatter = [[NSDateFormatter alloc] init];
    [detailFormatter setLocale:[NSLocale currentLocale]];
    [detailFormatter setDateFormat:@"yyyyMMddHHmm"];
    NSDate *date = [detailFormatter dateFromString:str];
    self.time.text = [[NSString stringWithFormat:@"%@", date] substringWithRange:NSMakeRange(0, 16)];
     //self.time.text = obj.time;
    
    
}


@end
