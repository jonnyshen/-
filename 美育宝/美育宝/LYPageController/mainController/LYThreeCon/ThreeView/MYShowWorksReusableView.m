//
//  MYShowWorksReusableView.m
//  美育宝
//
//  Created by apple on 16/7/12.
//  Copyright © 2016年 Jiayong Shen. All rights reserved.
//

#import "MYShowWorksReusableView.h"

@implementation MYShowWorksReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setResuableViewCellModel:(MYWorks *)works
{
    NSDateFormatter *detailFormatter = [[NSDateFormatter alloc] init];
    [detailFormatter setLocale:[NSLocale currentLocale]];
    [detailFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [detailFormatter dateFromString:works.timeLb];
    
    NSString *time = [NSString stringWithFormat:@"作品上传日期：%@", date];
    
    NSString *pieceTime = [time substringFromIndex:10];
    
    self.times.text = pieceTime;
    
//    self.titleLb.text = [NSString stringWithFormat:@"标题：%@",works.];
    
}

@end
